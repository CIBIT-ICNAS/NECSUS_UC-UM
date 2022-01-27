function [fCross] = designFixationCross( )
%DESIGNFIXATIONCROSS  init paramters of fixation cross (size in pixels)
%   output = designFixationCross(input)
%
%   Example
%   designFixationCross
%
%   See also

% Author: Bruno Direito (bruno.direito@uc.pt)
% Coimbra Institute for Biomedical Imaging and Translational Research, University of Coimbra.
% Created: 2022-01-27; Last Revision: 2022-01-27
   
% set of size of the arms of our fixation cross
fCross.fixCrossDimPix   = 20; %(pixels)

% set the line width for our fixation cross
fCross.lineWidthPix     = 2; %(pixels)
    
% set the coordinates for fixation cross in the center of the screen
fCross.xCrossCoords     = [-fCross.fixCrossDimPix fCross.fixCrossDimPix 0 0];
fCross.yCrossCoords     = [0 0 -fCross.fixCrossDimPix fCross.fixCrossDimPix];
fCross.CrossCoords      = [fCross.xCrossCoords; fCross.yCrossCoords];
     

end

