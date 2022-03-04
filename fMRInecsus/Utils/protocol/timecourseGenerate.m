function [end_time,bv]=timecourseGenerate(StimuliPrt)

% Retrieve copies of all the parameter of the protocol
parameters=StimuliPrt.parameters;
events=StimuliPrt.events;
bisi=10;
trial_duration=parameters.trial_duration;
type_range=parameters.events_multiplier;
conditions_range=parameters.conditions_range;
blocks=parameters.conditions_range;
event= parameters.events_multiplier;

ttime = 0;

% Compute the exact start time of each stimulation trial.
for k = 1:event*blocks
    if k == 1
        events{k,4} = ttime + bisi;
        ttime = events{k,4};
    else
        events{k,4} = ttime + events{k-1,3} + trial_duration;
        ttime = events{k,4};
    end
end

% Compute the exact time of the end of the experiment
% In other words this is the start time of the event 'END'
events{k+1,1} = 'END';
events{k+1,4} = ttime + events{k,3} + trial_duration;

% Keep time of END.
end_time = events{k+1,4};

% Each event ID in one column.
bv.start = zeros(type_range, conditions_range);

for j = 1:length(events)
    
    for k = 1:parameters.conditions_range
        
        if events{j,5} == k
            
            for h = 1:type_range
                if bv.start(h,k) == 0
                    break
                end
            end
            
            bv.start(h,k) = events{j,4};
            
        end
        
    end
end

% Compute the exact start and end time of each stimulation trial.
bv.start = bv.start*1000;
bv.end = bv.start+trial_duration*1000;

temp = cell2mat(events(:,4))*1000;
bv.fixation.start(1) = 1;

for k = 1:blocks*event+1
    
    if k == 1
        bv.fixation.start(k,1) = 1;
    else
        bv.fixation.start(k,1) = temp(k-1) + trial_duration*1000+1;
    end
    
    if k == blocks + 1
        bv.fixation.end(k,1) = temp(k);
    else
        bv.fixation.end(k,1) = temp(k) - 1;
    end
end

end