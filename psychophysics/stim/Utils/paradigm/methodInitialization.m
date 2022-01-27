function [methodStruct] = methodInitialization(methodName)
%METHODINITIALIZATION  Defines the type of algorithm used to estimate the
%contrast threshold.
%   methodStruct = methodInitialization(methodName)
%
%   Example
%   methodInitialization
%
%   See also

% Author: Bruno Direito (bruno.direito@uc.pt)
% Coimbra Institute for Biomedical Imaging and Translational Research, University of Coimbra.
% Created: 2022-01-27; Last Revision: 2022-01-27

switch methodName
    case 'QUEST'
        methodStruct=initializationQuest();
    case 'QUESTFSS'
        methodStruct=initializationQuestfss();
    case 'ConstantStimuli'
        methodStruct=initializationConstStim();
        
end

