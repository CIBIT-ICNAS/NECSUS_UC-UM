function [fCross] = designFixationCross( )
%DESINGFIXATIONCROSS Summary of this function goes here
%   Detailed explanation goes here
   
    % set of size of the arms of our fixation cross
    fCross.fixCrossDimPix=8;%20;
    % set the line width for our fixation cross
    fCross.lineWidthPix=2;
        
    % set the coordinates for fixation cross in the center of the screen
    fCross.xCrossCoords=[-fCross.fixCrossDimPix fCross.fixCrossDimPix 0 0];
    fCross.yCrossCoords=[0 0 -fCross.fixCrossDimPix fCross.fixCrossDimPix];
    fCross.CrossCoords=[fCross.xCrossCoords; fCross.yCrossCoords];
     

end

