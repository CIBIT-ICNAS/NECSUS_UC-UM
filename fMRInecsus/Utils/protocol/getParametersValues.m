%-------------------------------------------------------------------------%
% This function construct contain a variable wich one intances  of each   %
% CONDITION for each participant:                                         %
%                                                                         % 
% 1: Near threshold with SF 3.5 (NT_SF1)                                  %
% 2: Near threshold with SF 10 (NT_SF2)                                   %      
% 3: Glare threshold with SF 3.5 (GT_SF1)                                 %
% 4: Glare threshold with SF 10 (GT_SF2)                                  %
% 5: Glare near threshold with SF 3.5 (GNT_SF1)                           %
% 6: Glare near threshold with SF 10 (GNT_SF2)                            %
% 7: 2 x Glare threshold with SF 3.5 (dGT_SF1)                            %
% 8: 2 x Glare threshold with SF 10 (dGT_SF2)                             %
% 9: 2.5 x Glare threshold with SF 3.5 (dhGT_SF1)                         %
% 10: 2.5 x Glare threshold with SF 3.5 (dhGT_SF1)                        %

function [conditionsV] = getParametersValues(NT_SF,GT_SF,GNT_SF)

paramV=cell(4,3); % pre-allocate cell space for 10 conditions 

% create identification string labels in paramV
paramV{1,1}=sprintf('Near threshold (%)');
paramV{2,1}=sprintf('Glare threshold (%)');
paramV{3,1}=sprintf('Glare near threshold (%)');
paramV{4,1}=sprintf('2.5 x Glare threshold (%)');


% define contrast values for the participant
contrast(1)=str2num(NT_SF);
contrast(2)=str2num(GT_SF);
contrast(3)=str2num(GNT_SF);
contrast(4)=2.5*(str2num(GT_SF));

% assign contrast values in paramV
paramV{1,2}=contrast(1);
paramV{2,2}=contrast(2);
paramV{3,2}=contrast(3);
paramV{4,2}=contrast(4);


% assign spatial frequencies in paramV
paramV{1,3}=10;
paramV{2,3}=10;
paramV{3,3}=10;
paramV{4,3}=10;


% define ID of the event/condition (presentation of a gabor in the center of the screen)

for k=1:length(paramV)
    paramV{k,4}=k;
end

%Return the variable with all conditions
conditionsV=paramV;


end

