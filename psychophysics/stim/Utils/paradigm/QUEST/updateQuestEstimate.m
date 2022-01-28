function quest = updateQuestEstimate( quest, response )
%updateQuestEstimate Summary of this function goes here
%   Detailed explanation goes here

quest.q=QuestUpdate(quest.q, quest.contrastTrial, response);

end

