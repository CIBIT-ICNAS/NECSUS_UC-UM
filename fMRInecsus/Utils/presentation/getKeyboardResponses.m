function [response, hasResponded]=getKeyboardResponses(keys, startTime)

% Look for keyboard key press
[keyisdown, timestamp, keycode] = KbCheck;

response=[];
hasResponded=0;

if keyisdown == 1
   
    
    % Disable further button presses.
    hasResponded = 1;
    
    % Get key identifier.
    key = find(keycode); 
    
    % Subject responded 'View'.
    if  key==keys.keyView 
        % log file.
        response(1)=1;
       
    % Subject responded 'not view'.
    elseif  key == keys.keyNotView 
        % log file.
        response(1)=0;
    end
    response(2)=timestamp-startTime;
end


end
