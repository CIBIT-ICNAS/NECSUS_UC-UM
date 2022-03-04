function closeStim(w)

load('debug.mat')

% Restore originalCLUT.
Screen('LoadNormalizedGammatable', w, originalCLUT);

% Close PTB Screen and connections
Screen('CloseAll');
IOPort('CloseAll');
pnet('closeall');
ShowCursor;
Priority(0);


end