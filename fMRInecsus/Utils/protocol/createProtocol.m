function [stimuliPrt]=createProtocol(chaos,...
    nrepeats,...
    tr,...
    tr_factor,...
    pName,...
    conditions,...
    participant)

% Function to create the protocol  

% Build a variable with specific values of the treshold and near treshold
% for each participant (determined in psychophysical task)

% Each event is processed as a block. 
stimuliPrt.parameters.blocks_mutliplier=1; 
% Number of repetitions of each event.
stimuliPrt.parameters.events_multiplier=nrepeats; 
% Number of conditions.
stimuliPrt.parameters.conditions_range=length(conditions); 
% Repetition time.
stimuliPrt.parameters.tr=tr; 
% Event duration.
stimuliPrt.parameters.trial_duration=0.700;
% Inter stimuli interval.
stimuliPrt.parameters.block_isi=8;

% create a space for the complete protocol
stimuliPrt.events=cell(nrepeats*length(conditions),5);

% Repeat the conditions (16 trials of each contrast value) 

% --- The protocol is complete after 64 trials ---
condition = [];
for i=1:nrepeats
    condition = [condition;conditions];
end

for j=1:length(chaos)
    stimuliPrt.events{j,1}=condition{chaos(j),1}; % string with identification of conditions
    stimuliPrt.events{j,2}=condition{chaos(j),2}; %  contrast value 
    stimuliPrt.events{j,4}=condition{chaos(j),3}; % spatial frequency value 
    stimuliPrt.events{j,5}=condition{chaos(j),4}; % ID of each trial (1-4)
%     if debug(4)~=0
%          StimuliPrt.events{j,3}=1
%     else
        stimuliPrt.events{j,3}=tr*tr_factor(j)-stimuliPrt.parameters.trial_duration+tr; %fixation duration
%     end
end

% start and end times of each stimulation and fixation trial for BrainVoyager 
% end_time: the total time duration of the experiment

[endTime,bv]=timecourseGenerate(stimuliPrt);

% Add final timecourse values to 'stimuliPrt'.
stimuliPrt.timecourse.total_time=endTime;
stimuliPrt.timecourse.total_volumes=stimuliPrt.timecourse.total_time/stimuliPrt.parameters.tr;
stimuliPrt.timecourse.bv=bv;
stimuliPrt.timecourse.prtgen.chaos=chaos;
stimuliPrt.timecourse.prtgen.tr_factor=tr_factor;

% --- Create .prt file for brainvoyager ---
mkdir(['Output/',num2str(participant.ID),'/'],pName);

% stim conditions
for k=1:length(bv.start(1,:))
    
    fname=['Output/',num2str(participant.ID),'/',pName,'/ev',num2str(k),'.txt'];
    fid = fopen(fname, 'w');
    
    for kk=1:length(bv.start(:,k))
        
        fprintf(fid, '%g %g\n', bv.start(kk,k), bv.end(kk,k));
        
    end
    
    fclose(fid);
end

% fixation condition
fid = fopen(['Output/',num2str(participant.ID),'/',pName,'/fix.txt'], 'w');

for ksi=1:length(bv.fixation.start(:,1))
    
    if ksi == length(bv.fixation.start(:,1))
        fprintf(fid, '%g %g\n', bv.fixation.start(ksi,1), bv.fixation.end(ksi,1)+1);
    else
        fprintf(fid, '%g %g\n', bv.fixation.start(ksi,1), bv.fixation.end(ksi,1));
    end
    
end
        
fclose(fid);

return

