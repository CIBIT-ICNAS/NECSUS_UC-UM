function [methodStruct] =  getNextTrial(methodStruct, trialIdx)
%GETNEXTTRIAL  Get next contrast value considering the methods selected.
%   output = getNextTrial(input)
%
%   Example
%   getNextTrial
%
%   See also

% Author: Bruno Direito (bruno.direito@uc.pt)
% Coimbra Institute for Biomedical Imaging and Translational Research, University of Coimbra.
% Created: 2022-01-28; Last Revision: 2022-01-28

% If first trial return methodStruct.init else - getnexttrial
if trialIdx==1
    methodStruct.contrastTrial=methodStruct.init;
else
    switch methodStruct.name
        case 'QUEST'
            methodStruct=getNextQuestTrial(methodStruct);
        case 'QUESTFSS'
            methodStruct=getNextQuestfssTrial(methodStruct);
        case 'ConstantStimuli'
            methodStruct=getNextConstStimTrial(methodStruct);
    end
end

end