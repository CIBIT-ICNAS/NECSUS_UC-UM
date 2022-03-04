function glare = setBlink(glare)
%SETBLINK  Randomly select blinking dots.
%   output = setBlink(input)
%
%   Example
%   setBlink
%
%   See also

% Author: Bruno Direito (bruno.direito@uc.pt)
% Coimbra Institute for Biomedical Imaging and Translational Research, University of Coimbra.
% Created: 2022-01-28; Last Revision: 2022-01-28

glare.y = randsample(glare.s,size(glare.xymatrix,2), glare.numBlinkingDots);


end