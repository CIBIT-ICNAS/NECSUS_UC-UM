function RandomDotsKeysDouble_MRI_right_better_TESTE

debugging=0;sca
TriggerReceived = 1

info_nome = input('Nome: ', 's');
LoggingFileName = ['loggingfiles\Logfile_' char(info_nome) '.txt'];
LogFile = fopen(LoggingFileName, 'w');
fprintf(LogFile, '\t Motion LOC\n');
fprintf(LogFile, '\n');
fprintf(LogFile, '\nName: %s\n\n', info_nome);


doublebuffer=1;
screens=Screen('Screens');
screenNumber=max(screens);

if debugging
    [w, rect] = Screen('OpenWindow', screenNumber, 0, [0 0 512 384], 32, doublebuffer+1);
else
    [w, rect] = Screen('OpenWindow', screenNumber, 0,[], 32, doublebuffer+1);
end
    
    
if TriggerReceived
    [SynchBox, Lumina]= InitPorts();
    Screen('DrawText', w, 'Experiment is ready', 50,50,255);
    Screen('Flip', w);
    [gotTrigger, TimeStamp] = waitForTrigger(SynchBox,1,1000);
    if gotTrigger
        t0=TimeStamp;
        time=t0;
    else
        disp('Did not receive trigger - aborting stim');
        Screen('Close');
        sca; return
    end
else
	t0=GetSecs;
	time=t0;
end
    



    
    % ---------------------------------------------------------------------
    kill=0;             % stop the stimuli if an error occurs
    % ------------------------
  
    
    Priority(0);
    ShowCursor
    Screen('CloseAll');
    
    dir;
    coher;
    fps;
 
    fclose(LogFile)
% catch
%     Priority(0);
%     ShowCursor
%     Screen('CloseAll');
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function to initialize IOPorts for communication with SychBox and Lumina 
%
% Input:  
% Output: SynchBoxHandle, LuminaHandle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [SynchBoxHandle, LuminaHandle] = InitPorts()
IOPort('CloseAll');

SynchBoxHandle = IOPort('OpenSerialPort', 'COM2', 'BaudRate=57600 DataBits=8 Parity=None StopBits=1 FlowControl=None');
IOPort('Flush',SynchBoxHandle);
LuminaHandle = IOPort('OpenSerialPort','COM3');
IOPort('Flush',LuminaHandle);

