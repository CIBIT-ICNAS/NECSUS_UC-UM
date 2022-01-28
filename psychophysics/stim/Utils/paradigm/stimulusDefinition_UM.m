function [ stimuli ] = stimulusDefinition_UM( lcd, gabor, window)
%STIMULUSDEFINITION_UM  One-line description here, please.
%   [ stimuli ] = stimulusDefinition_UM( lcd, gabor, window)
%
%   Example
%   stimulusDefinition_UM
%
%   See also

% Author: Bruno Direito (bruno.direito@uc.pt)
% Coimbra Institute for Biomedical Imaging and Translational Research, University of Coimbra.
% Created: 2022-01-27; Last Revision: 2022-01-27



%-------------------------GABOR INFORMATION---------------------------%

% Get Spatial Frequency (cycles Per Pixel) and  gabor dimensions
stimuli.spatFreq        = computeSpatialFrequency(lcd.screenHeight,lcd.screenYpixels,lcd.viewingDistance,gabor.desiredSF); % Y axis - orientation of the stimuli.
stimuli.gaborDimPix     = computeGaborDimPix(lcd.screenWidth,lcd.screenXpixels,lcd.viewingDistance,gabor.gaborDimDegree);

% Sigma of Gaussian
stimuli.sigma           = stimuli.gaborDimPix/7;

%-------------------------TIME INFORMATION---------------------------%

% Query the frame duration.
stimuli.frameDuration   = Screen('GetFlipInterval', window);

% Presentation Time for the Gabor in seconds and frames.
stimuli.stimDurationSecs    = .5; %500msec
stimuli.stimDurationFrames  = round(stimuli.stimDurationSecs/stimuli.frameDuration);

% Interstimulus interval time in seconds and frames
stimuli.isiDurationSecs     = 1; %1000msec
stimuli.isiDurationFrames   = round(stimuli.isiDurationSecs / stimuli.frameDuration);

%-------------------- KEYBORD INFORMATION ------------------------%

stimuli.escapekey=KbName('Escape');
stimuli.keyNotView=KbName('q'); % key "not seeing the gabor"
stimuli.keyView=KbName('w'); % key to see

%---------------------- UTILS ---------------------------%
stimuli.countDownVals={'3','2','1'};
stimuli.introMessage='Press any key\n to continue.';

end

