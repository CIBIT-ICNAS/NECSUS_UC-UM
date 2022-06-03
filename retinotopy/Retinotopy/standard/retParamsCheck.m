function retParamsCheck(params);
% retParamsCheck - sanity checks of parameters
%
% SOD 10/2005: wrote it.

% some checks
if round(params.startScan/params.framePeriod) ~= params.startScan/params.framePeriod
	error(sprintf('start scan period (%.1f) is not an integer multiple of frame period (%.1f)!',...
        params.startScan,params.frameperiod));
end
if round(params.prescanDuration/params.framePeriod) ~= params.prescanDuration/params.framePeriod
	error(sprintf('Pre scan period (%.1f) is not an integer multiple of frame period (%.1f)!',...
        params.prescanDuration,params.frameperiod));
end
if round(params.period/params.framePeriod) ~= params.period/params.framePeriod
	error(sprintf('Scan period (%.1f) is not an integer multiple of frame period (%.1f)!',...
        params.period,params.frameperiod));
end

% priority check
if params.runPriority==0
	bn = questdlg('Warning: runPriority is 0!','warning','OK','Make it 7','Make it 1','OK');
	if strmatch(bn,'Make it 7')
		params.runPriority = 7;
	elseif strmatch(bn, 'Make it 1')
		params.runPriority = 1;
	end
end

% HACK to get correct timing for 2 rings experiment, since this one is all
% hard coded.
switch params.experiment
    case '2 rings'
        params.numCycles = 1;
end;

% verification
message = sprintf(['[%s]:Scan time and MR time frames:\n' ...
                   'Duration without stimulus (junk frames 1): %5.1f sec [%3d MRtf]\n' ...
                   'Duration of prescan (junk frames 2):       %5.1f sec [%3d MRtf]\n' ...
                   'Duration of data to be collected:          %5.1f sec [%3d MRtf]\n' ...
                   'Total stimulus duration:                   %5.1f sec [%3d MRtf]\n' ...
                   'Total scan duration:                       %5.1f sec [%3d MRtf] (%.1f minutes).'], ...
               mfilename,... % file name of currently running function
               params.startScan,  params.startScan/params.framePeriod, ...
               params.prescanDuration,  params.prescanDuration/params.framePeriod,...
               params.period.*params.numCycles,  params.period.*params.numCycles/params.framePeriod,...
               params.prescanDuration + params.period.*params.numCycles,...
               params.prescanDuration/params.framePeriod + params.period.*params.numCycles/params.framePeriod,...
               params.startScan+params.prescanDuration+params.period.*params.numCycles,...
               (params.startScan+params.prescanDuration+params.period.*params.numCycles)/params.framePeriod,...
               (params.startScan+params.prescanDuration+params.period.*params.numCycles)/60);
disp(message);