% this script generates a random sequence for the presentation of each 
%condition (event) and for each interstimuli interval (isi)

clear 

nrepeats=16; % number of repetions for each condition 
tr=2; % repetition time
% baseline for isi (4 possible isi)
%tr_base=[2;2;1;2;2;1;3;1;4;1;4;1;3;2;2;3;3;4;3;2;1;2;3;2;1;1;2;2;1;2;3;3;1;4;3;1;2;3;2;1;1;3;2;4;2;2;1;3;3;1;2;1;2;1;1;2;1;4;1;1;1;1;2;1;1;4;1;3;1;1]; 
tr_base=[3 2 1 1 3 2 3 3 1 1 1 2 2 2 1 2 1 1 1 1 3 2 1 2 2 1 1 1 3 3 2 1 1 2 1 2 1 1 1 1 1 2 1 2 2 2 1 1 3 1 2 3 1 3 2 1 1 3 2 1 1 1 3 2]';
tr_factor=tr_base(randperm(length(tr_base))); % random sequence for isi
chaos=randperm(4*nrepeats); % random sequence for the stimuli presentation  

%  save EVENTS_BOLD_GLARE_RUN2.mat nrepeats tr tr_factor chaos
%  save EVENTS_BOLD_GLARE_RUN2.lospp nrepeats tr tr_factor chaos

save CHANGE_ME.lospp bisi nrep tr tr_factor chaos