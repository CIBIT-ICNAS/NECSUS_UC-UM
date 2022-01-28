% Get the screen numbers
screens = Screen('Screens');

rgbInput = .5;

% Be careful.
Screen('Preference', 'SkipSyncTests', 1);

% Draw to the external screen if avaliable
scr.screenNumber=1;

% Open an on screen window
[window, windowRect] = Screen('OpenWindow',...
    scr.screenNumber,...
    [round(rgbInput*255),round(rgbInput*255),round(rgbInput*255)],... % Background RGB values.
    [],...
    [],...
    [],...
    [],...
    0);


load(fullfile(pwd, 'Utils', 'luminance', 'displayCLUT.mat'));

% Restore originalCLUT.
Screen('LoadNormalizedGammatable', window, displayCLUT);

% Close PTB Screen and connections
Screen('CloseAll');