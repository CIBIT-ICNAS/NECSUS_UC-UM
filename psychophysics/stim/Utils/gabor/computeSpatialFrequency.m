function [spatFreq] = computeSpatialFrequency(screenHeight,screenYpixels,viewingDistance,desiredSF)
% computeSpatialFrequency calculates the Spatial Frequency desired (cycles Per Pixel)
%   spatFreq = computeSpatialFrequency(screenHeight,screenYpixels,viewingDistance,desiredSF)
%
% 

    % pixel size  
    PixelSize = screenHeight/screenYpixels;
    
    % This is the projetion of one degree on the screen (cm)
    oneDegreeOnScreen = tan(pi/180)*viewingDistance ;
    
    % Number of pixels per degree
    pixelsInDegree = oneDegreeOnScreen/PixelSize;
    
    % How many pixels will each period/cycle occupy?
    pixelsPerPeriod = pixelsInDegree/desiredSF;  

    % How many periods/cycles are there in a pixel?
    spatFreq=1/pixelsPerPeriod;


end

