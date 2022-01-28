function [gaborDimPix] = computeGaborDimPix(screenWidth,screenXpixels,viewingDistance,gaborDimDegree)
% computeGaborDimPix calculates the Gabor dimensions in pixels  (cycles Per Pixel)
%   gaborDimPix = computeGaborDimPix(screenWidth,screenXpixels,viewingDistance,gaborDimDegree)
%
% 

pixSize=screenWidth/screenXpixels; % Pixel sizecm/pix.

SizeCm=2*viewingDistance*tan(pi*gaborDimDegree/(2*180)); % Dimension of gabor in cm.

gaborDimPix=round(SizeCm/pixSize); % Dimension of gabor in pixels.

end

