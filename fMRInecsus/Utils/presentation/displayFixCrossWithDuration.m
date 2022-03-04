function displayFixCrossWithDuration(window, fCross, white, duration)

% Present fixation cross for the pre-determined block_isi
waitUntil=GetSecs+duration;

% Display fixation cross in the center of the screen.
Screen('DrawLines',...
    window,...
    fCross.CrossCoords,...
    fCross.lineWidthPix,...
    white,...
    [fCross.xCenter fCross.yCenter]);
% Flip to the screen
Screen('Flip',window);


while GetSecs<waitUntil
    escapeButtonPress()
end


end