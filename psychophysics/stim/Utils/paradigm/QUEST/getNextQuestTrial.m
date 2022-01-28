function [ questStruct ] = getNextQuestTrial( questStruct )
%GETNEXTQUESTTRIAL Summary of this function goes here
%   Detailed explanation goes here


% Prob function mean and std.
t=QuestMean(questStruct.q);
sd=QuestSd(questStruct.q);

fprintf('Value of QUEST mean %f and sd %f.\n',t,sd);

% Get the Gabor contrast
% tTest=QuestQuantile(q);
% tTest=QuestMean(q)		% Recommended by King-Smith et al. (1994)
% tTest=QuestMode(q);		% Recommended by Watson & Pelli (1983)

if t<0
    t=0;
    fprintf('corrected to 0.\n');
end

fprintf('Next contrast test %f.\n', t );

% Return and avoid repetition.
questStruct.contrastTrial=t;

questStruct.trialIdx=questStruct.trialIdx+1;

if ( (questStruct.trialIdx==questStruct.nTrials) || (sd<questStruct.sCrit) )
    questStruct.isComplete=1;
end


end


