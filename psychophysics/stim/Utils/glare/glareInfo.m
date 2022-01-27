function glare = glareInfo()
%GLAREINFO  Creates object with parameters regarding embedded glare frame.
%   glare = glareInfo()
%
%   Example
%   glare = glareInfo()
%
%   See also

% Author: Bruno Direito (bruno.direito@uc.pt)
% Coimbra Institute for Biomedical Imaging and Translational Research, University of Coimbra.
% Created: 2022-01-27; Last Revision: 2022-01-27

glare=struct();

glare.glareDimDegree    = 12.5; % Dimension of the glare setup (degrees).

% Dot specs.
glare.glareDotWidth     = .3;  % width of dot (deg).
glare.spaceBetwDotsDeg  = 2; % spacing between dots (deg).

glare.s                 = RandStream('mlfg6331_64'); % Randomize dots blinking.
glare.numBlinkingDots   = 10;

glare.blinkOffTime      =.1; % (seconds)
glare.blinkInterval     =.3; % (seconds)

glare.y                 = [];
glare.xy                = [];

end
