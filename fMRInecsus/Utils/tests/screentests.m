
% Load gamma corrected scale for MR pojector
load(fullfile(pwd,'Utils','luminance','invertedCLUTMRscanner.mat'));

% luminance background required => 20 cd/m2
% Transform luminance required to rgb input.
rgbInput=luminanceToRgb(S.backgroundLum);% bits resolution - 8;

% Get the screen numbers
screens = Screen('Screens');

% Be careful.
Screen('Preference', 'SkipSyncTests', 1);

% Draw to the external screen if avaliable
scr.screenNumber=1;

    
scr.screenHeight=25.9; % Screen height (cm) nb. 34.7.
scr.screenWidth=54.6; % Screen width (cm).

%%


% Open an on screen window
[window, windowRect] = Screen('OpenWindow',...
    scr.screenNumber,...
    [round(rgbInput*255),round(rgbInput*255),round(rgbInput*255)],... % Background RGB values.
    [],...
    [],...
    [],...
    [],...
    0);
pause(1)
% upload inverse gamma function to screen - linearize lum.
originalCLUT=Screen('LoadNormalizedGammaTable',...
    window,...
    repmat(invertedCLUT, [3,1])' );

% Screen debug.
save('debug.mat','originalCLUT')

% Define white.
scr.white = WhiteIndex(scr.screenNumber);

% Get the size of the on screen window
[scr.screenXpixels, scr.screenYpixels] = Screen('WindowSize', window);
% screenXpixels=1024;
% screenYpixels=768;

% Fixation cross
% Get the centre coordinate of the window and create cross.
[xCenter, yCenter]=RectCenter(windowRect);
[fCross]=designFixationCross();
fCross.xCenter=xCenter;
fCross.yCenter=yCenter;

%%

% Gabor dimensions.
gabor.gaborDimPix=getGaborDimPix(scr,...
    60,...
    gabor.gaborDimDegree);

% Sigma of Gaussian.
gabor.sigma=gabor.gaborDimPix/5;

% Build a procedural gabor texture.
gabortex=CreateProceduralGabor(window,...
    gabor.gaborDimPix,...
    gabor.gaborDimPix,...
    [],...% nonSymmetric.
    [rgbInput, rgbInput, rgbInput, 0.0],...
    [],...
    []);

% Desired spatial frequency.
desiredSpatFreq=10;

% Gabor creation based on desired spatial frequency.
spatFreq=computeSpatialFrequency(scr.screenHeight,...
    scr.screenYpixels,...
    40,...
    desiredSpatFreq);

%%

% Wait for...
DrawFormattedText(window,'Starting. Wait 2 seconds.','center','center',scr.white);
Screen('Flip',window); % Flip to the screen.

waitUntil=GetSecs+2;
while GetSecs<waitUntil
    [response, hasResponded]=waitResponse(S,0, S.keys, 1, 0);
end

% Change the blend function to draw an antialiased fixation
% point in the centre of the screen.
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
% Display fixation cross.
duration=2;
displayFixCrossWithDuration(window, fCross, scr.white, duration)

%%
contrast=3;

% Set the right blend function for drawing the gabors.
Screen('BlendFunction', window, 'GL_ONE', 'GL_ZERO');
% Draw the Gabor.
Screen('DrawTexture', window, gabortex, [], [], gabor.angle, [], [], ...
    [], [], kPsychDontDoRotation, [gabor.phase+180, spatFreq, gabor.sigma, contrast, gabor.aspectratio, 0, 0, 0]);
% Flip to the screen
Screen('Flip', window);
% Wait for...
waitUntil=GetSecs+S.prt.parameters.trial_duration;
while GetSecs<waitUntil
    [response, hasResponded]=waitResponse(S,0, S.keys, 1, 0);
end

%%
% Change the blend function to draw an antialiased fixation
% point in the centre of the screen.
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
% Display fixation cross.
duration=2;
displayFixCrossWithDuration(window, fCross, scr.white, duration)


contrast=5;

% Set the right blend function for drawing the gabors.
Screen('BlendFunction', window, 'GL_ONE', 'GL_ZERO');

% Draw the Gabor.
Screen('DrawTexture', window, gabortex, [], [], gabor.angle, [], [], ...
    [], [], kPsychDontDoRotation, [gabor.phase+180, spatFreq, gabor.sigma, contrast, gabor.aspectratio, 0, 0, 0]);
% Flip to the screen
Screen('Flip', window);
% Wait for...
waitUntil=GetSecs+S.prt.parameters.trial_duration;
while GetSecs<waitUntil
    [response, hasResponded]=waitResponse(S,0, S.keys, 1, 0);
end

%%

closeStim(window)