function [output t0] = deviceSV6011(command,port)
% deviceSV6011 - read 3T_projector_SV6011_Avotec_1024x768 scanner trigger and subject response box
%
% output = deviceSV6011(command)
%
% commands: 'open'  - opens the communication line
%           'check' - open, report on and close all available ports
%                     useful for finding your device port
%           'read'  - read all that came in (and flush)
%                     output = read, t0 = time of reading.
%           'trigger' - binary output whether trigger occurred (flush
%                       everything else)
%                       output = boolean, t0 = time of trigger.
%           'wait for trigger' - wait untill trigger is received before
%                                continuing
%           'button' - buttons that were pushed (all, triggers are flushed)
%                      output = buttons, t0 = time of reading.
%                      (idem: 'response')
%           'close'  - close the communication line
% port:     device port to be checked (see /dev/cu.* if OS/X and COM port number <n> for %Win)
%           A negative device port does not check serial device but will
%           check the internal keyboard instead. This is useful for the
%           avoiding the command 'wait for trigger' and 'response' etc, 
%           during testing of the stimulus without the serial device.
%
% Device button-to-number configuration:
%     [51]3
% [49]1    [50]2
%     [52]4
%      |
%      |
%      V
%     wire
%
% MR trigger = 115
%
% 2009/05 SOD: wrote it as a wrapper for the UMC device using comm.m serial
%              port interface by Tom Davis (http://www.mathworks.com/matlabcentral/fileexchange/4952).
% 2009/11 BMH & SOD: rewrote wrapper for intel mac, using Tom Davis' other
%              function, SerialComm, which is now integrated into matlab.
%              Commands for SerialComm are the same as for comm.
%              Inserted switch for intel macs to choose the right port (2)
%              or port 3 for G4 macs
%  2014/01 SVL: modified it for Siemens 3T scanner projector_SV6011_Avotec at 1024x768 resolution device using IOPort  function
%              Inserted changes for Win32 and Win64 architectures        
%  2014/02 SF: centered the stimuli in displayParams.m and used IOPort function to ascertain for the
%              close of all devices

%fprintf(1,'[%s]:Running command %s: \n',mfilename,command);

% default
if ~exist('port','var') || isempty(port)
%     if strcmp(computer('arch'), 'maci')
%         port = 2; % for macbook pro
%     else
%         port =3; % for G4 powerbook
%     end
      if strcmp(computer('arch'), 'win64')  % for Win64 architecture; change for different windows OS
          port = 4; % for 3T Siemens scanner PCwin
      end
end

% for testing and debugging without Siemens 3T scanner SV6011_Avotec device (needs psychtoolbox)
if port<0
    [output t0]=keyboardCheck(command);
    return
end

% parameters
id.device = port; % device(s) connected either to Win64 PC or Win32 PC COMports
id.trigger = 237;
% id.trigger_response = 115; % In case scanner sends a response after computer writes/sends signal to scanner; uncomment line 108 and comment line 109
persistent handleCOM3;
persistent handleCOM2;
id.response = 49:52;

% initiate output
output = [];
t0 = [];

% execute command
switch(lower(command))
    case {'check'} % useful for finding your device id/port
        deviceSV6011('open',port);
        deviceSV6011('close',port);


    case {'open','start'}
        fprintf(1,'[%s]:Opening device %s: \n',mfilename,'COM2');
        [handleCOM2, errmsg] = IOPort('OpenSerialPort','COM2','BaudRate=38400 DataBits=8 Parity=None StopBits=1 FlowControl=None');
        fprintf(1,'[%s]:Result %s: \n',mfilename,errmsg);
        
        fprintf(1,'[%s]:Opening device %s: \n',mfilename,'COM3');
        [handleCOM3, errmsg] = IOPort('OpenSerialPort','COM3');
        fprintf(1,'[%s]:Result %s: \n',mfilename,errmsg);
        
    case {'read'}
        [output, timeStamp, errmsg] = IOPort('Read',handleCOM3);
        fprintf(1,'[%s]:Read Result %s: \n',mfilename,errmsg);
        
    case {'trigger'}
%         %[nwritten, when, errmsg] = IOPort('Write', handleCOM2, id.trigger);
%         %fprintf(1,'[%s]:Write Result [%d] %s: \n',mfilename,nwritten, errmsg);
        [t, when, errmsg] = IOPort('Read', handleCOM2, 1, 1);
        fprintf(1,'[%s]:Read Result [%d] %s: \n',mfilename,t, errmsg);
        if ~isempty(t) & any(t==id.trigger)
            output = true;
        end
        

    case {'waitfortrigger','wait for trigger'}
        % load mex file for more accuracy
        GetSecs;
        % keep checking for trigger while also releasing some CPU
        while(1)
            [t, when, errmsg] = IOPort('Read',handleCOM2);
%             if ~isempty(t) & any(t==id.trigger_response)
            if ~isempty(t) & any(t==id.trigger)
                output = true;
                t0 = GetSecs;
                break;
            else
                % give some time back to PC-win
                WaitSecs(0.01);
            end
        end

    case {'button','response','responses'}
        % everything that is not a trigger
        [t, when, errmsg] = IOPort('Read',handleCOM3);
        if ~isempty(t)
            %t = t(t==id.response(1) | t==id.response(2) | t==id.response(3) | t==id.response(4));
            t = t(t~=id.trigger);
            output = t;
            t0 = GetSecs;
        end

    case {'close'}
        fprintf(1,'[%s]:Closing devices.\n',mfilename);
        IOPort('Close',handleCOM2);
        IOPort('Close',handleCOM3);

    otherwise
        error('[%s]:Unknown command %s',mfilename,lower(command));
end

if isempty(output),
    output = false;
end

return
%------------------------------------------

%------------------------------------------
function [output t0]=keyboardCheck(command)
% simulate device output

switch(lower(command))
    case {'read','trigger','button','response','responses'}
            [output t0] = KbCheck;

    case {'waitfortrigger','wait for trigger'}
        while(1)
            [output t0] = KbCheck;
            if output
                break;
            else
                % give some time back to PC-win
                WaitSecs(0.01);
            end
        end

    otherwise
        output = [];
        t0 = [];
        % do nothing

end

return
%------------------------------------------


