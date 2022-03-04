function [response, hasResponded]=getResponseBoxResponses(keys, responseBoxHandle, startTime)

% Look for response box key press
[key, timestamp, errmsg] = IOPort('Read',responseBoxHandle);

response=[];
hasResponded=0;

if ~isempty(key)
    % Disable further button presses.
    hasResponded = 1;
   
    IOPort('Flush',responseBoxHandle);
  
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




