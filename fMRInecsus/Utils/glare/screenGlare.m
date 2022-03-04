function screenGlare(glare, wScreen, color, blink)
%SCREENGLARE  Prepares the glare frame for drawing
%   output = screenGlare(input)
%
%   Example
%   screenGlare
%
%   See also

% Author: Bruno Direito (bruno.direito@uc.pt)
% Coimbra Institute for Biomedical Imaging and Translational Research, University of Coimbra.
% Created: 2022-01-28; Last Revision: 2022-01-28


% [minSmoothPointSize, maxSmoothPointSize, minAliasedPointSize, maxAliasedPointSize] = Screen(%DrawDots , windowPtr, xy [,size] [,color] [,center] [,dot_type][, lenient]);

if blink
    Screen('DrawDots', wScreen, glare.xymatrix(:,glare.y), glare.glareDotWidthPixs, color);
else
    Screen('DrawDots', wScreen,  glare.xymatrix, glare.glareDotWidthPixs, color);  
end

end



