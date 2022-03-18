function [log] = runStim_UM(S, scr, gabor, glare)

% --- STIMULI PRESETS ----

% --- scr variable represents screen features. ---
% --- gabor variable represents the stimuli gabor features. ---

% Trick suggested by the PTB authors
syncTrick();


try
    % -- if DEBUG off.
    if ~S.debug

        % screen number.
        ScrNumber = 0;
        
        % Load gamma corrected scale for MR pojector.
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
        % screen number.
        ScrNumber = 1;

        % Load gamma corrected scale for LCD monitor
        load(fullfile(pwd,'Utils','luminance','invertedCLUT.mat'));
        totalTrials=1;
    end
    
    % Set "real time priority level"
    Priority(2)
    
    % luminance background required => 20 cd/m2
    % Transform luminance required to rgb input.
    rgbInput    = luminanceToRgb(S.backgroundLum);% bits resolution - 8;

    backgrColor =  [round(rgbInput*255),round(rgbInput*255),round(rgbInput*255)];
    
    %  ---- START DISPLAY ----
    
    % SCREEN SETUP
    % Get the screen numbers
    screens=Screen('Screens');
    
    % Be careful. --------------
    Screen('Preference', 'SkipSyncTests', 1);
    
    % Draw to the external screen if avaliable
    scr.screenNumber        = ScrNumber;% max(screens);
    
    % Open an on screen window
    [window, windowRect]    = Screen('OpenWindow',...
        scr.screenNumber,...
        [round(rgbInput*255),round(rgbInput*255),round(rgbInput*255)],... % Background RGB values.
        [],...
        [],...
        [],...
        [],...
        0);
    
    % Linearize monitor gamma.
    % Upload inverse gamma function to screen - linearize lum.
    originalCLUT            = Screen('LoadNormalizedGammaTable',...
        window,...
        repmat(invertedCLUT, [3,1])' );
    % Screen debug.
    save('debug.mat','originalCLUT')
    % Define white.
    scr.white               = WhiteIndex(scr.screenNumber);
    % Get the size of the on screen window
    [scr.screenXpixels, scr.screenYpixels]  = Screen('WindowSize', window);
    
  
    % Retreive the maximum priority number
    topPriorityLevel        = MaxPriority(window);  
    
    % ---- Fixation cross elements. ----
    % Get the centre coordinate of the window and create cross.
    [fCross]                = designFixationCross();
    [fCross.xCenter, fCross.yCenter] = RectCenter(windowRect);
    
    % ---- PARAMETER SETUP ----
    % ---- GABOR. ----
    % Gabor dimensions.
    gabor.gaborDimPix       = getGaborDimPix(scr,...
        scr.viewingDistance,...
        gabor.gaborDimDegree);
        % Sigma of Gaussian.
    gabor.sigma             = gabor.gaborDimPix/5;  
    % Gabor creation based on desired spatial frequency.
    gabor.spatFreq          = computeSpatialFrequency(scr.screenHeight,...
        scr.screenYpixels,...
        scr.viewingDistance,...
        gabor.spatFreqCdM);
    % Build a procedural gabor texture.
    gabortex                = CreateProceduralGabor(window,...
        gabor.gaborDimPix,...
        gabor.gaborDimPix,...
        0,...% nonSymmetric.
        [rgbInput rgbInput rgbInput 0.0],...
        [],...
        []);
    
    % ---- Screen and stim definitions. ----
    % Measure the vertical refresh rate of the monitor.
    ifi                     = Screen('GetFlipInterval', window);
    
    % Length of time and number of frames we will use for each drawing test.
    numSecs                 = 1;
    numFrames               = round(numSecs/ifi);
    
    % Number of frames to wait.
    waitframes              = 1;
    numFrames               = numFrames/waitframes;

    flipoffset              = .1;
    vbl_ar=[];
    vblNext_ar=[];

    % ---- Glare. ----
    if S.hasGlare
        % Prepare Glare frame.
        glare               = designGlare(glare, scr, fCross);

        t2NextBlink         = glare.blinkInterval;
    
        t2OffBlink          = glare.blinkInterval+glare.blinkOffTime;
        
        screenGlare(glare, window, scr.white, 0);

    end

    %-----------------------------------------------------------------%
    %                      EXPERIMENTAL LOOP                          %
    %-----------------------------------------------------------------%
    
    % --- Stimuli presentation ----
    log=struct();
     
    % DEBUG? SYNCBOX trigger
    if ~S.debug
        [gotTrigger, log.triggerTimeStamp] = waitForTrigger(syncBoxHandle,1,1000);
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

    vbl                     = Screen('Flip', window, [], 1);
   
    % --- Main loop ---
    time.start              = GetSecs;
    fprintf('[Chrono] Start: %.3f. \n', time.start);
    
    % Change the blend function to draw an antialiased fixation
    % point in the centre of the screen.
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

    % Wait until fixation cross period ends.
    durationInSecs          = S.prt.parameters.block_isi;

    for frame = 1: round(numFrames * durationInSecs)        
        if S.hasGlare            
            screenGlare(glare, window, scr.white, 0);            
            if t2NextBlink<(GetSecs-time.start)
                % fprintf('blink. %.2f seconds \n', GetSecs-time.start);                               
                glare           = setBlink(glare); % Select subset of off dots
                screenGlare(glare, window, backgrColor, 1); % Prepare stim for flip.                
                t2OffBlink      = t2NextBlink + glare.blinkOffTime; % time to turn off blink.
                t2NextBlink     = t2NextBlink + glare.blinkOffTime + glare.blinkInterval; % time offset to next blink                
                % fprintf('next blink. %.2f seconds \n', t2NextBlink);
            end
            if t2OffBlink < (GetSecs-time.start)
                screenGlare(glare, window, backgrColor, 1);
            end
        end
     
        % Draw the fixation cross.
        displayFixCross(window, fCross, scr.white)

        % Flip to the screen.
        vbl                 = Screen('Flip', window, vbl + (waitframes - flipoffset) * ifi); % Flip to the screen.
        % vbl                 = Screen('Flip', window); % Flip to the screen.
        vbl_ar(end+1)       = vbl;
        vblNext_ar(end+1)       = (waitframes - flipoffset) * ifi;
        
    end
    
    totDur = GetSecs - time.start;
    fprintf('[Chrono] End first fixation cross: %.3f. \n', totDur);
    
    for trialIdx = 1:totalTrials
        
        hasResponded        = 0;
        response            = [];
        
        % -- Contrast presentation --
        % Get contrast value.
        contrast            = S.prt.events{trialIdx,2};
        % Display contrast.
        % Set the right blend function for drawing the gabors.
        Screen('BlendFunction', window, 'GL_ONE', 'GL_ZERO');
        
        % Chrono.
        time.stimPres(trialIdx)     = GetSecs-time.start;

        % Wait until fixation cross period ends.
        durationInSecs              = ( ( (time.stimPres(trialIdx) + S.prt.parameters.trial_duration) - (GetSecs-time.start) ) );

        fprintf('[Chrono] Contrast display (trialIdx %d): %.3f. \n', trialIdx, GetSecs-time.start);
        fprintf('[ChronoDur] Contrast duration : %.3f \n', durationInSecs);

        for frame = 1: round(numFrames * durationInSecs)        
            if S.hasGlare            
                screenGlare(glare, window, scr.white, 0);            
                if t2NextBlink<(GetSecs-time.start)
                    % fprintf('blink. %.2f seconds \n', GetSecs-time.start);                               
                    glare           = setBlink(glare); % Select subset of off dots
                    screenGlare(glare, window, backgrColor, 1); % Prepare stim for flip.                
                    t2OffBlink      = t2NextBlink + glare.blinkOffTime; % time to turn off blink.
                    t2NextBlink     = t2NextBlink + glare.blinkOffTime + glare.blinkInterval; % time offset to next blink                
                    % fprintf('next blink. %.2f seconds \n', t2NextBlink);
                end
                if t2OffBlink < (GetSecs-time.start)
                    screenGlare(glare, window, backgrColor, 1);
                end
            end
         
           % Draw the Gabor.
           Screen('DrawTexture', window, gabortex, [], [], gabor.angle, [], [], ...
                [], [], kPsychDontDoRotation, [gabor.phase+180, gabor.spatFreq, gabor.sigma, contrast, gabor.aspectratio, 0, 0, 0]);
    
            % Flip to the screen.
            vbl             = Screen('Flip', window, vbl + (waitframes - flipoffset) * ifi); % Flip to the screen.
            vbl_ar(end+1)       = vbl;
            vblNext_ar(end+1)   = (waitframes - flipoffset) * ifi;
        end

        fprintf('[Chrono] End contrast display (trialIdx %d): %.3f. \n', trialIdx, GetSecs-time.start);

        
        % -- Fixation cross presentation --

        % --- wait for response --- %

        fprintf('[Chrono] Fixation Cross display (trialIdx %d): %.3f. \n', trialIdx, GetSecs-time.start);

        % Wait until fixation cross period ends.
        durationInSecs      = S.prt.events{trialIdx,3};
        fprintf('[ChronoDur] Fixation duration : %.3f \n', durationInSecs);
            
        for frame = 1: round(numFrames * durationInSecs)  
                   
            if S.hasGlare            
                screenGlare(glare, window, scr.white, 0);            
                if t2NextBlink<(GetSecs-time.start)
                    % fprintf('blink. %.2f seconds \n', GetSecs-time.start);                               
                    glare           = setBlink(glare); % Select subset of off dots
                    screenGlare(glare, window, backgrColor, 1); % Prepare stim for flip.                
                    t2OffBlink      = t2NextBlink + glare.blinkOffTime; % time to turn off blink.
                    t2NextBlink     = t2NextBlink + glare.blinkOffTime + glare.blinkInterval; % time offset to next blink                
                    % fprintf('next blink. %.2f seconds \n', t2NextBlink);
                end
                if t2OffBlink < (GetSecs-time.start)
                    screenGlare(glare, window, backgrColor, 1);
                end
            end
            
            % Draw the fixation cross.
            displayFixCross(window, fCross, scr.white)

            % Flip to the screen.
            vbl             = Screen('Flip', window, vbl + (waitframes - flipoffset) * ifi); % Flip to the screen.
            vbl_ar(end+1)       = vbl;     
            vblNext_ar(end+1)   = (waitframes - flipoffset) * ifi;

            % --- Get response. ---

            [response, hasResponded]        = waitResponse(S,...
                response,...
                hasResponded,...
                time.start);
        end

        fprintf('[Chrono] End fixation Cross display (trialIdx %d): %.3f. \n', trialIdx, GetSecs-time.start);

        % end of main loop
        log(trialIdx).response              = response;
        log(trialIdx).contrast              = contrast;
        
    end
    
    time.finished                           = GetSecs-time.start;
    fprintf('[Chrono] Stim End: %.3f. \n', time.finished);
    
    fprintf('The experiment is finished.\n');
    fprintf('Closing setup.\n\n');
    
    
    % Elements to close stim, clear vars, etc.
    closeStim(window);
    
    fprintf('Total duration of the stimuli was %.3f.\n', time.finished);

%     save('vbl.mat','vbl_ar', 'vblNext_ar')
    
catch me

    me 

    % Elements to close stim, clear vars, etc.
    closeStim(window);
    
    % Display error.
    rethrow(me);
    
end



