function escapeButtonPress()

% Check keyboard key pressed.
[keyPress,chronoKey,keyCode] = KbCheck;

if keyPress
    if keyCode(KbName('escape')) == 1 %Quit if "Esc" is pressed
        throw(MException('user:escape','Aborted by escape key.'))
    end
end