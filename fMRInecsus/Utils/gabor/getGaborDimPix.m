function [gaborDimPix] = getGaborDimPix(screen, viewingDistance, gaborDimDegree)

pixSize = screen.screenWidth/screen.screenXpixels;  % pixel sizecm/pix

SizeCm = 2*viewingDistance*tan(pi*gaborDimDegree/(2*180));  % dimension of gabor in cm

gaborDimPix=round(SizeCm/pixSize); %dimension of gabor in pixels

end

