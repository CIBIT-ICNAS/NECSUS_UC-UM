function [ response, time, model] = runStim_UM( ptb, lcd, gabor, glare, methodStruct )
%RUNSTIM_UM  stim based on preset variables
%   [ response, time, model] = runStim_UM( ptb, lcd, gabor, glare, methodStruct )
%
%   Example
%   runStim_UM
%
%   See also

% Author: Bruno Direito
% Created: 2022-01-27
% Copyright 2022 University of Coimbra.


% --------------------------------------------------------
% --- Initialize steps (variables, set defaults, etc.) ---
% --------------------------------------------------------

response            = [];

% Keyboard "normalization" of Escape key.
KbName('UnifyKeyNames');

% normalized luminance required to rgb input - 20 cd/m2.
rgbInput            = luminanceToRgb(ptb.backgroundLum, lcd.pathToGreyData);

% Estimate the background color - 20 cd/m2 (normalized).
backgrColor         = repmat(round(rgbInput*255), 1, 3);

% -----------------
% --- PTB setup ---
% -----------------

Priority(2); % Set "real time priority level".

%%%%%%%%% Be careful.%%%%%%%%%%
Screen('Preference', 'SkipSyncTests', 1);

% Open a screen window.
[wScreen, windowRect]   = Screen('OpenWindow',...
    ptb.screenNumber,...
    backgrColor,...
    [],...
    [],...
    [],...
    [],...
    0);

% Measure the vertical refresh rate of the monitor.
ifi                     = Screen('GetFlipInterval', wScreen);

% Length of time and number of frames we will use for each drawing test.
numSecs                 = 1;
numFrames               = round(numSecs/ifi);

% Numer of frames to wait.
waitframes              = 1;

% ---------------------
% --- START DISPLAY ---
% ---------------------

try
    % Suppress chars on command window during stim.
    ListenChar(2);
    
    % MONITOR SETUP / Linearize monitor gamma table.
    % upload inverse gamma function to screen - linearize lum.

    % Load gamma-corrected CLUT (color look-up table) - variable "invertedCLUT".
    load(fullfile(pwd,'Utils','luminance','invertedCLUT.mat'));

    displayCLUT    = Screen('LoadNormalizedGammaTable',...
        wScreen,...
        repmat(invertedCLUT, [3,1])' );
    
    % Screen debug - in the case that an error occurs with corrected gamma table.
    save(fullfile(pwd,'Utils','luminance','displayCLUT.mat'), 'displayCLUT')
    
    % Monitor default values.
    % Define white.
    white           = WhiteIndex(ptb.screenNumber); % required to display fixation cross
        
    % Define center of the screen.
    [sCenter.xCenter, sCenter.yCenter]      = RectCenter(windowRect);
    
    % Get the size of the on screen window.
    [lcd.screenXpixels, lcd.screenYpixels]  = Screen('WindowSize', wScreen);
    
    % Set the text size.
    Screen('TextSize', wScreen, 50);
    
    % Fixation cross.
    fCross          = designFixationCross();
    
    % Glare.
    if ptb.hasGlare
        % Prepare Glare frame.
        glare       = designGlare(glare, lcd, sCenter);
        
    end
    
    % Hide cursor.
    HideCursor;
    
    % --- STIMULUS PARAMETER SETUP ---
    stim            = stimulusDefinition_UM(lcd, gabor, wScreen);
    disableNorm     = [];
    preContrastMultiplier = [];
    
    % Build a procedural gabor texture - PTB3
    gabortex        = CreateProceduralGabor(wScreen,...
        stim.gaborDimPix,...
        stim.gaborDimPix,...
        [],...
        [rgbInput,rgbInput,rgbInput,0.0],...
        disableNorm,...
        preContrastMultiplier);
    
    
    %-----------------------------------------------------------------%
    %                      EXPERIMENTAL LOOP
    %-----------------------------------------------------------------%
    
    
    % --- Stimuli presentation ----
    
    % Display fixation cross in the center of the screen and wait for
    % keyboard key press to start countdown (stim.countDownVals).
    
    DrawFormattedText(wScreen,...
        stim.introMessage,...
        'center',...
        'center',...
        white);
    
    Screen('Flip', wScreen); % Flip to the screen.
    
    KbStrokeWait;
    
    % Present countdown.
    for countDownIdx = 1:numel(stim.countDownVals)
        
        % Add glare frame if HASGLARE flag is true.
        if ptb.hasGlare
            screenGlare(glare, wScreen, white, 0);
        end
        
        % Display number countDown.
        
        DrawFormattedText(wScreen,...
            stim.countDownVals{countDownIdx},...
            'center',...
            'center',...
            white);
        
        Screen('Flip', wScreen); % Flip to the screen.
        WaitSecs(1);
    end
    
    % --- Main loop ---
    
    vbl         = Screen('Flip', wScreen, [], 1);
    
    time.start  = GetSecs;
    
    t2NextBlink = glare.blinkInterval;
    
    t2OffBlink  = glare.blinkInterval+glare.blinkOffTime;
    
    trialIdx    = 0;
    
    while ~methodStruct.isComplete
        trialIdx     = trialIdx+1;
        
        % Get next contrast based on the method selected.
        methodStruct = getNextTrial(methodStruct, trialIdx);
        fprintf('next trial contrast: %f. \n', methodStruct.contrastTrial)
        
        % Present fixation cross + frame.
        
        % Chrono.
        time.fCrossPres(trialIdx)   = GetSecs-time.start;
        
        % %         % Change the blend function to draw an antialiased fixation
        % %         % point in the centre of the screen.
        % %         Screen('BlendFunction', wScreen, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
        
        
        % Wait until fixation cross period ends.
        DurationInSecs              = ( (time.fCrossPres(trialIdx)+stim.isiDurationSecs) - (GetSecs-time.start) );
 
        for frame = 1: round(numFrames * DurationInSecs)
            
            if ptb.hasGlare
                
                screenGlare(glare, wScreen, white, 0);
                
                if t2NextBlink<(GetSecs-time.start)
                    fprintf('blink. %.2f seconds \n', GetSecs-time.start);
                    
                    
                    glare           = setBlink(glare); % Select subset of off dots
                    screenGlare(glare, wScreen, backgrColor, 1); % Prepare stim for flip.
                    
                    t2OffBlink      = t2NextBlink + glare.blinkOffTime; % time to turn off blink.
                    t2NextBlink     = t2NextBlink + glare.blinkOffTime + glare.blinkInterval; % time offset to next blink
                    
                    fprintf('next blink. %.2f seconds \n', t2NextBlink);
                end
                
                if t2OffBlink < (GetSecs-time.start)
                    screenGlare(glare, wScreen, backgrColor, 1);
                end
                
            end
            
            % Draw the fixation cross.
            Screen('DrawLines',...
                wScreen,...
                fCross.CrossCoords,...
                fCross.lineWidthPix,...
                white,...
                [sCenter.xCenter sCenter.yCenter]);
            
            % Flip to the screen.
            vbl = Screen('Flip', wScreen, vbl + (waitframes - 0.5) * ifi); % Flip to the screen.
            
        end
        
        
        % --- Present Gabor ---
        % Chrono.
        time.stimPres(trialIdx)     = GetSecs-time.start;
        
        
        % Wait until fixation cross period ends.
        DurationInSecs              = ( ( (time.stimPres(trialIdx)+stim.stimDurationSecs) - (GetSecs-time.start) ) );
        
        for frame = 1: round(numFrames * DurationInSecs)
            
            % Set the right blend function for drawing the gabors.
            Screen('BlendFunction', wScreen, 'GL_ONE', 'GL_ZERO');
            
            if ptb.hasGlare
                
                screenGlare(glare, wScreen, white, 0);
                
                if t2NextBlink<(GetSecs-time.start)
                    fprintf('blink. %.2f seconds \n', GetSecs-time.start);
                    glare           = setBlink(glare); % Select subset of off dots
                    screenGlare(glare, wScreen, backgrColor, 1); % Prepare stim for flip.
                    
                    t2OffBlink      = t2NextBlink + glare.blinkOffTime; % time to turn off blink.
                    t2NextBlink     = t2NextBlink + glare.blinkOffTime + glare.blinkInterval; % time offset to next blink
                    fprintf('next blink. %.2f seconds \n', t2NextBlink);
                end
                
                if t2OffBlink <(GetSecs-time.start)
                    screenGlare(glare, wScreen, backgrColor, 1);
                end
                
            end
            
            
            % Draw the Gabor.
            Screen('DrawTextures', wScreen, gabortex, [], [], gabor.angle, [], [], ...
                [], [], kPsychDontDoRotation, [gabor.phase+180, stim.spatFreq, stim.sigma, methodStruct.contrastTrial, gabor.aspectratio, 0, 0, 0]');
            
             % Flip to the screen.
            vbl = Screen('Flip', wScreen, vbl + (waitframes - 0.5) * ifi); % Flip to the screen.
            
        end
        
        
        % --- wait for response --- %
            
        hasResponse=false;
        
        while ~hasResponse
            
            if ptb.hasGlare
                
                screenGlare(glare, wScreen, white, 0);
                
                if t2NextBlink<(GetSecs-time.start)
                    fprintf('blink. %.2f seconds \n', GetSecs-time.start);
                    
                    glare       = setBlink(glare); % Select subset of off dots
                    screenGlare(glare, wScreen, backgrColor, 1); % Prepare stim for flip.
                    
                    t2OffBlink  = t2NextBlink + glare.blinkOffTime; % time to turn off blink.
                    t2NextBlink = t2NextBlink + glare.blinkOffTime + glare.blinkInterval; % time offset to next blink
                    
                    fprintf('next blink. %.2f seconds \n', t2NextBlink);
                end
                
                if t2OffBlink <(GetSecs-time.start)
                    screenGlare(glare, wScreen, backgrColor, 1);
                end
                
            end
            
            % Draw the fixation cross.
            Screen('DrawLines',...
                wScreen,...
                fCross.CrossCoords,...
                fCross.lineWidthPix,...
                white,...
                [sCenter.xCenter sCenter.yCenter]);
            
            
            % Flip to the screen.
            vbl = Screen('Flip', wScreen, vbl + (waitframes - 0.5) * ifi); % Flip to the screen.        
            
            
            % Now we wait for a keyboard button signaling the observers response.
            % The 'm' key signals a positive response
            %   (the participaant saw the stimuli)
            % and the 'z' key a negative response
            %   (the participant was not able to see the stimuli).
            % You can also press escape if you want to exit the program.
            
            
            % Check key pressed.
            [~,chronoKey,keyCode] = KbCheck;
            % Time stamp of the answer.
            time.respkeyPressed(trialIdx)=chronoKey-time.start;
            % If participant saw gabor, then.
            if keyCode(stim.keyView)
                
                hasResponse = true;
                % Save results.
                response(trialIdx,:) = [trialIdx,...
                    methodStruct.contrastTrial,...
                    1];
                
                % Update estimation models.
                methodStruct=updateEstimate(methodStruct,1);
                
                % Else, if participant did not saw gabor, then.
            elseif keyCode(stim.keyNotView)
                hasResponse = true;
                
                % Save results.
                response(trialIdx,:) = [trialIdx,...
                    methodStruct.contrastTrial,...
                    0];
                % Update estimation models.
                methodStruct=updateEstimate(methodStruct,0);
                
                % Exit program if escape key is pressed.
            elseif keyCode(stim.escapekey)
                hasResponse = true;
                methodStruct.isComplete=1;
                fprintf('The participant pressed the escape key.\n');
                break;
                
            end
        end
        
        methodStruct.last=methodStruct.contrastTrial;
        % fprintf('Value of QUEST %f and of the last sample %f.\n',QuestMean(q),last);
    end
    
    time.finished=GetSecs-time.start;
    
    fprintf('The experiment is finished.\n');
    fprintf('Closing setup.\n');
    
    % Display fixation cross in the center of the screen and wait for
    % keyboard key press to start countdown (5 to 1 with 0.5
    % sec interval).
    DrawFormattedText(wScreen,...
        'Finished. Processing results.',...
        'center',...
        'center',...
        white);
    Screen('Flip',wScreen); % Flip to the screen.
    
    pause(1);
    
    model=methodStruct.q;
    
    % Restore originalCLUT.
    load(fullfile(pwd,'Utils','luminance','displayCLUT.mat'))
    Screen('LoadNormalizedGammatable', wScreen, displayCLUT);
    
    % Close PTB Screen.
    Screen('CloseAll');
    ShowCursor;
    Priority(0);
    
    % suppress chars on command window during stim.
    ListenChar(0);
     
catch me
    warning(me.message);
    % suppress chars on command window during stim.
    ListenChar(0);
    % Restore originalCLUT.
    load(fullfile(pwd,'Utils','luminance','displayCLUT.mat'));
    Screen('LoadNormalizedGammatable', wScreen, displayCLUT);
    
    % Close PTB Screen.
    Screen('CloseAll');
    ShowCursor;
    Priority(0);
    rethrow(me);
    
    
end


end

