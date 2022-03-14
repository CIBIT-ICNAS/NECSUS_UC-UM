function displayFixCross(window, fCross, white)

% Display fixation cross in the center of the screen.
Screen('DrawLines',...
    window,...
    fCross.CrossCoords,...
    fCross.lineWidthPix,...
    white,...
    [fCross.xCenter fCross.yCenter]);
% Flip to the screen
Screen('Flip',window);

escapeButtonPress()



end