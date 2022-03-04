function [log] = runStim(S, scr, gabor)

% --- STIMULI PRESETS ----

% --- scr variable represents screen features. ---
% --- gabor variable represents the stimuli gabor features. ---

% Trick suggested by the PTB authors
syncTrick();


try
    % -- if DEBUG off.
    if ~S.debug
        % Load gamma corrected scale for MR pojector
        load(fullfile(pwd,'Utils','luminance','invertedCLUTMRscanner.mat'));
        
        % Open SerialPorts.
        % SyncBox.
        syncBoxHandle=IOPort('OpenSerialPort',...
            S.syncBoxCom,...
            'BaudRate=57600 DataBits=8 Parity=None StopBits=1 FlowControl=None');
        IOPort('Flush',syncBoxHandle);
        % ResponseBox.
        S.responseBoxHandle=IOPort('OpenSerialPort',...
            S.responseBoxCom);
        IOPort('Flush',S.responseBoxHandle);
        
         % Stimuli presentation loop.
        totalTrials=length(S.prt.events);
       
    else
        % Load gamma corrected scale for LCD monitor
        load(fullfile(pwd,'Utils','luminance','invertedCLUT.mat'));
        totalTrials=5;
    end
    
    % Set "real time priority level"
    Priority(2)
    
    % luminance background required => 20 cd/m2
    % Transform luminance required to rgb input.
    rgbInput=luminanceToRgb(S.backgroundLum);% bits resolution - 8;
    
    %  ---- START DISPLAY ----
    
    % SCREEN SETUP
    % Get the screen numbers
    screens=Screen('Screens');
    
    % Be careful. --------------
    Screen('Preference', 'SkipSyncTests', 1);
    
    % Draw to the external screen if avaliable
    scr.screenNumber=0;% max(screens);
    
    % Open an on screen window
    [window, windowRect] = Screen('OpenWindow',...
        scr.screenNumber,...
        [round(rgbInput*255),round(rgbInput*255),round(rgbInput*255)],... % Background RGB values.
        [],...
        [],...
        [],...
        [],...
        0);
    
    % Linearize monitor gamma.
    % Upload inverse gamma function to screen - linearize lum.
    originalCLUT=Screen('LoadNormalizedGammaTable',...
        window,...
        repmat(invertedCLUT, [3,1])' );
    % Screen debug.
    save('debug.mat','originalCLUT')
    % Define white.
    scr.white = WhiteIndex(scr.screenNumber);
    % Get the size of the on screen window
    [scr.screenXpixels, scr.screenYpixels]=Screen('WindowSize', window);
    
    
    % Fixation cross elements.
    % Get the centre coordinate of the window and create cross.
    [fCross]=designFixationCross();
    [fCross.xCenter, fCross.yCenter]=RectCenter(windowRect);
    
    % ---- PARAMETER SETUP ----
    % GABOR
    % Gabor dimensions.
    gabor.gaborDimPix=getGaborDimPix(scr,...
        scr.viewingDistance,...
        gabor.gaborDimDegree);
        % Sigma of Gaussian.
    gabor.sigma=gabor.gaborDimPix/5;  
    % Gabor creation based on desired spatial frequency.
    gabor.spatFreq=computeSpatialFrequency(scr.screenHeight,...
        scr.screenYpixels,...
        scr.viewingDistance,...
        gabor.spatFreqCdM);
    % Build a procedural gabor texture.
    gabortex=CreateProceduralGabor(window,...
        gabor.gaborDimPix,...
        gabor.gaborDimPix,...
        0,...% nonSymmetric.
        [rgbInput rgbInput rgbInput 0.0],...
        [],...
        []);
    

    
    %-----------------------------------------------------------------%
    %                      EXPERIMENTAL LOOP                          %
    %-----------------------------------------------------------------%
    
    % --- Stimuli presentation ----
    log=struct();
     
    % DEBUG? SYNCBOX trigger
    if ~S.debug
        [gotTrigger, log.triggerTimeStamp]=waitForTrigger(syncBoxHandle,1,1000);
        if gotTrigger
            HideCursor;
            disp('Trigger OK! Starting stimulation...');
        else
            disp('Absent trigger. Aborting...');
            throw
        end
    else
        % Present info and countdown.
        stimDebugInit(window, scr.white)
    end
    
    
    % --- Main loop ---
    time.start=GetSecs;
    fprintf('[Chrono] Start: %.3f. \n', time.start);
    
    
    % Change the blend function to draw an antialiased fixation
    % point in the centre of the screen.
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    % Display fixation cross.
    totDur=S.prt.parameters.block_isi;
    displayFixCrossWithDuration(window, fCross, scr.white, totDur)
    
    totDur
    fprintf('[Chrono] End first fixation cross: %.3f. \n', GetSecs-time.start);
    
    for trialIdx = 1:totalTrials
        
        hasResponded=0;
        response=[];
        
        % -- Contrast presentation --
        
        % Get contrast value.
        contrast=S.prt.events{trialIdx,2};
        
        % Display contrast.
        
        % Set the right blend function for drawing the gabors.
        Screen('BlendFunction', window, 'GL_ONE', 'GL_ZERO');
        
        % Draw the Gabor.
        Screen('DrawTexture', window, gabortex, [], [], gabor.angle, [], [], ...
            [], [], kPsychDontDoRotation, [gabor.phase+180, gabor.spatFreq, gabor.sigma, contrast, gabor.aspectratio, 0, 0, 0]);
        
        % Flip to the screen
        Screen('Flip', window);
        
        % Wait for...
        % waitUntil=GetSecs+S.prt.parameters.trial_duration;
        
        totDur=totDur+S.prt.parameters.trial_duration;
        
        %while GetSecs<waitUntil
        while GetSecs<totDur+time.start
            [response, hasResponded]=waitResponse(S,...
                response,...
                hasResponded,...
                time.start);
        end
        
        totDur
        fprintf('[Chrono] Contrast display: %.3f. \n', GetSecs-time.start);
        
        % -- Fixation cross presentation --
        
        % Change the blend function to draw an antialiased fixation
        % point in the centre of the screen.
        Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
        
        % Display fixation cross in the center of the screen.
        Screen('DrawLines',...
            window,...
            fCross.CrossCoords,...
            fCross.lineWidthPix,...
            scr.white,...
            [fCross.xCenter fCross.yCenter]);
        
        % Flip to the screen
        Screen('Flip',window);
        
        % Fixation Should last until the end of the pre-determined
        % inter stimulus interval for the trialIdx block: 'event{k,3}'
        
        % Wait for...
        % waitUntil=GetSecs+S.prt.events{trialIdx,3};
        
        totDur=totDur+S.prt.events{trialIdx,3};
        %while GetSecs<waitUntil
        while GetSecs<totDur+time.start
            [response, hasResponded]=waitResponse(S,...
                response,...
                hasResponded,...
                time.start);
        end
        
        % end of main loop
        log(trialIdx).response=response;
        log(trialIdx).contrast=contrast;
        
        totDur
        fprintf('[Chrono] Fixation Cross display: %.3f. \n', GetSecs-time.start);
    end
    
    time.finished=GetSecs-time.start;
    fprintf('[Chrono] Stim End: %.3f. \n', time.finished);
    
    fprintf('The experiment is finished.\n');
    fprintf('Closing setup.\n\n');
    
    
    % Elements to close stim, clear vars, etc.
    closeStim(window);
    
    fprintf('Total duration of the stimuli was %.3f.\n', time.finished);
    
catch me
    % Elements to close stim, clear vars, etc.
    closeStim(window);
    
    % Display error.
    rethrow(me);
    
end



