% QuestInitialization  Initializes the PTB QUEST method
%   C = QuestInitialization() creates a structure with defualt values.
%
%   See also PTB, QUEST.
function [questStruct] = initializationQuest()

questStruct=struct(); %init struct

questStruct.name='QUEST';

% Estimation based on previous data / initial guess
questStruct.estMean=6.2980;
questStruct.estStd=4.3992;

% QUEST parameters
questStruct.deltInt=.15;
questStruct.direction=0;

questStruct.trialIdx=1;
questStruct.init=6;
questStruct.last=questStruct.init;

% Watson AB, Pelli DG (1983) Quest: A Bayesian adaptive psychometric method. Percept Psychophys 33:113–120.
questStruct.pThreshold=0.82;
questStruct.beta=3.5;
questStruct.delta=0.05;
questStruct.gamma=0.5;

questStruct.grain=0.05;
questStruct.dim=250;

questStruct.plotIt=1;

% Provide our prior knowledge to QuestCreate, and receive the data struct "q".
% tGuess=quest.estMean;
% tGuessSd=quest.estStd;

%q=QuestCreate(tGuess,tGuessSd,pThreshold,beta,delta,gamma, grain, dim);
questStruct.q=QuestCreate(questStruct.estMean,...
    questStruct.estStd,...
    questStruct.pThreshold,...
    questStruct.beta,...
    questStruct.delta,...
    questStruct.gamma,...
    questStruct.grain,...
    questStruct.dim);

% This adds a few ms per call to QuestUpdate, but otherwise the pdf will underflow after about 1000 trials.
questStruct.q.normalizePdf=1;


% --- Stopping criteria ----
% stopping handle.
questStruct.isComplete=0;
% Stopping criteria (total number of trials tried).
questStruct.nTrials=100;
% Stopping criteria (i.e. sd=QuestSd(.q) less than ?).
questStruct.sCrit=0.15;

end