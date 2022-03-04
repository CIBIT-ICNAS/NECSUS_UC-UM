function [conditions] = setConditions(p)
%SETCONDITIONS  This function construct contain a variable wich one intances of each CONDITION for each participant:                                        
%                                                                         
% 1: Near threshold with SF 10 (NT)                                            
% 2: Glare threshold with SF 10 (GT)                                     
% 3: Glare near threshold with SF 10 (GNT)                                    
% 4: 2.5 x Glare threshold with SF 10 (GT)  
%   output = setConditions(input)
%
%   Example
%   setConditions
%
%   See also

% Author: Bruno Direito (bruno.direito@uc.pt)
% Coimbra Institute for Biomedical Imaging and Translational Research, University of Coimbra.
% Created: 2022-03-04; Last Revision: 2022-03-04


% pre-allocate cell space for 4 conditions 
conditions=cell(4,3); 

% Create identification string labels in parameters.
conditions{1,1}=sprintf('Near threshold (%%)');
conditions{2,1}=sprintf('Glare threshold (%%)');
conditions{3,1}=sprintf('Glare near threshold (%%)');
conditions{4,1}=sprintf('2.5 x Glare threshold (%%)');

% Assign contrast values in parameters.
conditions{1,2}=p.psychophysic.NT;
conditions{2,2}=p.psychophysic.GT;
conditions{3,2}=p.psychophysic.GNT;
conditions{4,2}=2.5*(p.psychophysic.GT);

% Assign spatial frequencies in parameters.
conditions{1,3}=10;
conditions{2,3}=10;
conditions{3,3}=10;
conditions{4,3}=10;

% Define ID of the event/condition 
% Presentation of a gabor in the center of the screen).
for k=1:length(conditions)
    conditions{k,4}=k;
end

end

