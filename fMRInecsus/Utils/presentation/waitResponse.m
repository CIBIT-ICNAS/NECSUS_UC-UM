function [response, hasResponded] = waitResponse(S, response, hasResponded, startTime)

% Escape button press.
escapeButtonPress()

if ~hasResponded
    
    response=[];
    
    % Responses
    if S.debug
        [response, hasResponded]=getKeyboardResponses(S.keys,startTime);
        
    elseif ~S.debug
        [response, hasResponded]=getResponseBoxResponses(S.keys,S.responseBoxHandle, startTime);
    end
    
end