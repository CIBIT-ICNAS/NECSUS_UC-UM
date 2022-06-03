% Short MATLAB example that uses the Eyelink and Psychophysics Toolboxes
% This is the example as shown in the EyelinkToolbox article in BRMIC
% Cornelissen, Peters and Palmer 2002), but updated to also work on the
% PC version of the toolbox, and uses some new routines.
%
% Adapted after "Psychtoolbox\PsychHardware\EyelinkToolbox\EyelinkDemos\
% ShortDemos\EyelinkExample.m"
%
% HISTORY
%
% mm/dd/yy
% 07/01/08 js 	redone the structure of the experiment and added
%		integration messages to the EyeLink Data Viewer software
% 07/14/08 js 	added code to set your own EDF file name before opening
%		the experiment graphics
% 07/13/10  fwc made to work with new toolbox with callback and updated to
%               enable eye image display, added "cleanup" function,
%               reenabled try-catch
% 09/20/12 srresearch updated to allow:
%               1. Transfer the image to host. (STEP 7.1)
%               2. Change the calibration colors and turn on/off the
%                   calibration beep. (STEP 6)
%               3. End trials by button box. (STEP 7.5)

clear all;
commandwindow;

% list of images used for the trial
imageList = {'town.bmp' 'town_blur.bmp' 'composite.bmp'};


% dummymode: Omit, or set to 0 to attempt real initialization,
%            set to 1 to enforce to use initializedummy for dummy mode
dummymode=1;

try
    % STEP 1
    % Added a dialog box to set your own EDF file name before opening
    % experiment graphics. Make sure the entered EDF file name is 1 to 8
    % characters in length and only numbers or letters are allowed.
    prompt = {'Enter tracker EDF file name (1 to 8 letters or numbers)'};
    dlg_title = 'Create EDF file';
    num_lines= 1;
    def     = {'DEMO'};
    answer  = inputdlg(prompt,dlg_title,num_lines,def);
    %edfFile= 'DEMO.EDF'
    edfFile = answer{1};
    fprintf('EDFFile: %s\n', edfFile );
    
    % STEP 2
    % Open a graphics window on the main screen
    % using the PsychToolbox's Screen function.
    fprintf('sceen will start\n');
    screenNumber=max(Screen('Screens'));
    fprintf('screen started\n');
    [window, wRect]=Screen('OpenWindow', screenNumber, 0,[],32,2);
    Screen(window,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    
    % STEP 3
    % Provide Eyelink with details about the graphics environment
    % and perform some initializations. The information is returned
    % in a structure that also contains useful defaults
    % and control codes (e.g. tracker state bit and Eyelink key values).
    el=EyelinkInitDefaults(window);
    
    
    
    % STEP 4
    % Initialization of the connection with the Eyelink Gazetracker.
    % exit program if this fails.
    
    if ~EyelinkInit(dummymode)
        fprintf('Eyelink Init aborted.\n');
        cleanup;  % cleanup function
        return;
    end
    
    % the following code is used to check the version of the eye tracker
    % and version of the host software
    sw_version = 0;
    [v vs]=Eyelink('GetTrackerVersion');
    fprintf('Running experiment on a ''%s''tracker.\n', vs );
    fprintf('tracker version v=%d\n', v);
    
    
    
    % open file to record data to
    i = Eyelink('Openfile', edfFile);
    if i~=0
        fprintf('Cannot create EDF file ''%s'' ', edffilename);
        cleanup;
        return;
    end
    
    
    
    Eyelink('command', 'add_file_preamble_text ''Recorded by EyelinkToolbox demo-experiment''');
    [width, height]=Screen('WindowSize', screenNumber);
    
    
    % STEP 5
    % SET UP TRACKER CONFIGURATION
    % Setting the proper recording resolution, proper calibration type,
    % as well as the data file content;
    Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, width-1, height-1);
    Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, width-1, height-1);
    % set calibration type.
    Eyelink('command', 'calibration_type = HV9');
    % set parser (conservative saccade thresholds) - this is the default 'cognitive configuration'
    Eyelink('command', 'saccade_velocity_threshold = 30');
    Eyelink('command', 'saccade_acceleration_threshold = 8000');
    
    
    % set EDF file contents using the file_sample_data and
    % file-event_filter commands
    % set link data thtough link_sample_data and link_event_filter
    Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
    Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
    
    % check the software version
    % add "HTARGET" to record possible target data for EyeLink Remote
    if sw_version >=4
        Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,HTARGET,GAZERES,STATUS,INPUT');
        Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,HTARGET,STATUS,INPUT');
    else
        Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,GAZERES,STATUS,INPUT');
        Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS,INPUT');
    end
    
    
    % allow to use the big button on the eyelink gamepad to accept the
    % calibration/drift correction target
    Eyelink('command', 'button_function 5 "accept_target_fixation"');
    
    % make sure we're still connected.
    if Eyelink('IsConnected')~=1 && dummymode == 0
        fprintf('not connected, clean up\n');
        cleanup;
        return;
    end
    
    
    % STEP 6
    % Calibrate the eye tracker
    % setup the proper calibration foreground and background colors
    el.backgroundcolour = [128 128 128];
    el.calibrationtargetcolour = [0 0 0];
    
    % parameters are in frequency, volume, and duration
    % set the second value in each line to 0 to turn off the sound
    el.cal_target_beep=[600 0.5 0.05];
    el.drift_correction_target_beep=[600 0.5 0.05];
    el.calibration_failed_beep=[400 0.5 0.25];
    el.calibration_success_beep=[800 0.5 0.25];
    el.drift_correction_failed_beep=[400 0.5 0.25];
    el.drift_correction_success_beep=[800 0.5 0.25];
    % you must call this function to apply the changes from above *******************************************************
    EyelinkUpdateDefaults(el);
    
    % Hide the mouse cursor;
    Screen('HideCursorHelper', window);
    %start setup (calibration etc)
    EyelinkDoTrackerSetup(el);
    
    % STEP 7
    % Now starts running individual trials;
    % You can keep the rest of the code except for the implementation
    % of graphics and event monitoring
    % Each trial should have a pair of "StartRecording" and "StopRecording"
    % calls as well integration messages to the data file (message to mark
    % the time of critical events and the image/interest area/condition
    % information for the trial)
    
    

    %% Star of ret
    
    % ret - program to start retinotopic mapping experiments (firstly conceived to run under OSX)
%       
%
% 06/2005 SOD Ported to OSX. If the mouse is invisible,
%             moving it to the Dock usually makes it reappear.
% 10/2005 SOD Several changes, including adding gui.

% clean up - it's good to clean up but mex files are extremely slow to be
% loaded for the first time in MacOSX, so I chose not to do this to speed
% things up.
close all;close hidden;
clear mex;clear all;
IOPort('CloseAll');

%pack;

% ask parameters with user interface
params = retMenu;
drawnow;

% now set rest of the params
params = setRetinotopyParams(params.experiment, params);

% set response device
% old way keep for compatibility
params.devices = getDevices(false);
if isempty(params.devices.keyInputExternal)
    params.devices.keyInputExternal = params.devices.keyInputInternal;
end
% new way
params.devices.SV6011port = 4; % default = 4 for testing with device; set to -1 for testing without device
fprintf('[%s]:Using port %d.\n',mfilename,params.devices.SV6011port);
deviceSV6011('open',params.devices.SV6011port);

% go
oldLevel = Screen('Preference', 'Verbosity', 1);
doRetinotopyScan(params);
Screen('Preference', 'Verbosity', oldLevel);

% clean up
deviceSV6011('close',params.devices.SV6011port);

%%End ret

% STEP 8
    % End of Experiment; close the file first
    % close graphics window, close data file and shut down tracker
    
    Eyelink('Command', 'set_idle_mode');
    WaitSecs(0.5);
    Eyelink('CloseFile');
    
    % download data file
    try
        fprintf('Receiving data file ''%s''\n', edfFile );
        status=Eyelink('ReceiveFile');
        if status > 0
            fprintf('ReceiveFile status %d\n', status);
        end
        if 2==exist(edfFile, 'file')
            fprintf('Data file ''%s'' can be found in ''%s''\n', edfFile, pwd );
        end
    catch
        fprintf('Problem receiving data file ''%s''\n', edfFile );
    end
    
    % STEP 9
    % run cleanup function (close the eye tracker and window).
    %cleanup;
catch
    %this "catch" section executes in case of an error in the "try" section
    %above.  Importantly, it closes the onscreen window if its open.
    %cleanup;
end %try..catch.


% Cleanup routine:
    %function cleanup;
% Shutdown Eyelink:
Eyelink('Shutdown');

% Close window:
%sca;
Screen('CloseAll');
commandwindow;


% Restore keyboard output to Matlab:
% % ListenChar(0);