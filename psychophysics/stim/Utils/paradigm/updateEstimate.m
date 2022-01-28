function [methodStruct] =  updateEstimate(methodStruct, answer)
%UPDATEESTIMATE  Update contrast estimate based on the method selected.
%   updateEstimate(methodStruct, answer)
%
%   Example
%   updateEstimate
%
%   See also

% Author: Bruno Direito (bruno.direito@uc.pt)
% Coimbra Institute for Biomedical Imaging and Translational Research, University of Coimbra.
% Created: 2022-01-28; Last Revision: 2022-01-28

switch methodStruct.name
    case 'QUEST'
        methodStruct=updateQuestEstimate( methodStruct, answer );
    case 'QUESTFSS'
        methodStruct=updateQuestfssEstimate( methodStruct, answer );
        
    case 'ConstantStimuli'
        % do nothing - no update required.
end

end
