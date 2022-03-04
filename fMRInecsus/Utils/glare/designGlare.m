function [g] = designGlare( g, lcd, sCenter)
%DESIGNGLARE setup the embedded glare frame. Convert visual angles to
%pixels etc.
%   [glare] = designGlare( glare, lcd, sCenter)
%
%   Example
%   designGlare
%
%   See also

% Author: Bruno Direito (bruno.direito@uc.pt)
% Coimbra Institute for Biomedical Imaging and Translational Research, University of Coimbra.
% Created: 2022-01-27; Last Revision: 2022-01-27


% --- Estimate size considering the visual angle glare ---

% Pixel size to compute pxeil per cm.
pixSize             = lcd.screenWidth/lcd.screenXpixels; % Pixel sizecm/pix.

% Frame.
% Dimension of the embedded glare frame.
SizeCm              = 2*lcd.viewingDistance*tan(pi*g.glareDimDegree/(2*180)); 
% Dimension of glare square in pixels.
g.glareDimPix       = round(SizeCm/pixSize); 

% Each dot.
% Set of witdh of the glare dots.
dotSizeCm           = 2*lcd.viewingDistance*tan(pi*g.glareDotWidth/(2*180)); % Dimension of gabor in cm.
% Dimension of glare dots in pixels.
g.glareDotWidthPixs = round(dotSizeCm/pixSize);

% Spacing between dots.
SizeSpacingCm       = 2*lcd.viewingDistance*tan(pi*g.spaceBetwDotsDeg/(2*180)); % Dimension of gabor in cm.
g.glareSpacingPixs  = round(SizeSpacingCm/pixSize);

% Get positions of the dots that are part of the frame.
g.xymatrix          = getGlareSidePos( g,...
                        sCenter.xCenter - g.glareDimPix, ...
                        sCenter.yCenter - g.glareDimPix, ...
                        sCenter.xCenter + g.glareDimPix, ...
                        sCenter.yCenter + g.glareDimPix);

end
