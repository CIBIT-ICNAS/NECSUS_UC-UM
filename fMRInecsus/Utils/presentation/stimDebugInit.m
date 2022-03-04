function stimDebugInit(window, white)

countDownVals={'3', '2', '1'};

% Display fixation cross in the center of the screen and wait for
% keyboard key press to start countdown (5 to 1 with 0.5
% sec interval).

DrawFormattedText(window,'press any key.','center','center',white);
Screen('Flip',window); % Flip to the screen.

KbWait;

% Present countdown.
for countDownIdx = 1:numel(countDownVals)
    % Display number countDown.
    DrawFormattedText(window,...
        countDownVals{countDownIdx},...
        'center',...
        'center',...
        white);
    Screen('Flip',window); % Flip to the screen.
    WaitSecs(1);
end

end