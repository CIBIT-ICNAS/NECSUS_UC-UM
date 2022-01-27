function [linInput] = luminanceToRgb(lumRequired, pathToGreyData)
%LUMINANCETORGB  Get luminance based on gamma-corrected table
%   output = luminanceToRgb(input)
%
%   Example
%   luminanceToRgb
%
%   See also

% Author: Bruno Direito (bruno.direito@uc.pt)
% Coimbra Institute for Biomedical Imaging and Translational Research, University of Coimbra.
% Created: 2022-01-27; Last Revision: 2022-01-27


if nargin < 2  
    pathToGreyData  = fullfile(pwd,...
        'Utils',...
        'luminance',...
        'RGB_Lab95.mat');
 
    
    disp('[Warning] default: lcd monitor lab95.')
end

if nargin < 1
    lumRequired    = 20;
end

% --- load data ---
% LCD monitor RGB matrix on input
% returns RGB_lum (true output), FitParamters (gamma, offset)
load(pathToGreyData);

% Get maximum luminance from the display.
maxLum      = max(RGB_lum(:,2));

% Assuming linear CLUT.
linInput    = lumRequired/maxLum;

end