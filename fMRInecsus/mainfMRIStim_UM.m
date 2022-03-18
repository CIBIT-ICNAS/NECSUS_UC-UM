%% INIT

% close any open connection or PTB screen
IOPort('Close All');
Screen('Close All');
pnet('closeall');
sca;

% clear all variables and commanda window.
clear all;
close all;
clc;

%% Set path
% --- addpath to required folders ---
addpath(genpath('Utils'));
addpath('Protocols');
addpath('Output');

%% PRESETS

% debug run?
DEBUG   = 1;

% ---- PARTICIPANT data / To be determined and updated in each scanning session ----

% Create participant variable with psychopsysics and meta data.
ID      = 'DEBUG'; % 'sub-NECSUS-UC001'
GT      = 1.3; % Threshold with GLARE.
NT      = 1.5; % Near Threshold without GLARE.
GNT     = 1.6; % Near Threshold with GLARE.

% Create Participant data variable.
PARTICIPANT     = setParticipant(ID, NT, GT, GNT);

% ---- MRI setup ----
VIEWINGDISTANCE = 178.75; %156.5;  40; debug
RESPONSEBOXCOM  = 'COM3';
SYNCBOXCOM      = 'COM2';

%% CREATE STIM

S               = struct();
S.debug         = DEBUG;

% ---- preset CONDITIONS / STIMULI ----
SPATIALFREQ     = 10;
BACKGROUNDLUM   = 20;
S.hasGlare      = 1; % input('glare/noglare?:','s'); % glare setup

% get the conditions for each participant
conditions      = setConditions(PARTICIPANT);

% --- Glare INFORMATION ---
glare           = glareInfo();

% --- GABOR INFORMATION ---
gabor           = gaborInfo(SPATIALFREQ);

% ---- PROTOCOL CREATION ----
% Get fMRI RUN protocol.
[pFilename, pPath]  = uigetfile({'*.lospp','LoSpP Protocol (*.lospp)';}...
    ,'Open Protocol',...
    'Protocols/');

% Confirmation of fMRI PROTOCOL file for the EVENT-RELATED experiment
% returns an error.
if ( ~ischar(pPath) || ~ischar(pFilename) )
    errordlg('You must choose a file!','Error','modal');
    return
end
% Path for the file and load the experiment parameters.
locationFile    = strcat(pPath, pFilename);
load(locationFile,'-mat','chaos','nrepeats','tr','tr_factor');
% Protocol name.
[~,pName,~]     = fileparts(pFilename);
% Create the complete protocol with the subject-specific contrast values.
S.prt           = createProtocol(chaos,...
    nrepeats,...
    tr,...
    tr_factor,...
    pName,...
    conditions,...
    PARTICIPANT);

% --- PREPARATION ---
% Box connectivity.
S.responseBoxCom    = RESPONSEBOXCOM;
S.syncBoxCom        = SYNCBOXCOM;

if S.debug
    % input hack (for debugging)
    S.iomethod      = 0; % 0-keyboard | 1-lumina response
    % Turn on (1) or off (0) synchrony with scanner console
    S.syncbox       = 0;
    % --- debug monitor ---
    scr             = scrInfo(50); %VIEWINGDISTANCE=50;
else
    S.iomethod      = 1; % 0-keyboard | 1-lumina response
    % Turn on (1) or off (0) synchrony with scanner console
    S.syncbox       = 1; 
    % --- MR monitor ---
    scr             = scrMRInfo(VIEWINGDISTANCE);

    % Create text box with summary information about the experiment and wait
    %   for mouse click to continue the program and enter the experiment
    text = [pFilename,...
    ' protocolName |',num2str(S.prt.timecourse.total_volumes),...
    ' vols | ',...
    num2str(S.prt.timecourse.total_time),...
    ' secs'];

    uiwait(msgbox(text,'ContrastTask','modal'));
end

% Keyboard "normalization" of Escape key.
KbName('UnifyKeyNames');
S.escapekey         = KbName('Escape');
% BackgroundLum definiton of variable - bg color.
S.backgroundLum     = BACKGROUNDLUM;
% DEBUG - keyboard or Response box.
S.keys              = iomethod(S.iomethod);

%% Run STIMULI 
% run experiment and return 'logdata' with responses
[logdata] = runStim_UM(S, scr, gabor, glare);

%% Save data
% Asks for saving the data
saveData(PARTICIPANT, S, logdata, pFilename);



