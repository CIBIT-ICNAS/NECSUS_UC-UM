function [ lcd ] = lcdInfo(VIEWINGDISTANCE, pathToGreyData)
%LCDINFO sets lcd info into a structure
%   [lcd] = lcdInfo(VIEWINGDISTANCE, pathToGreyDat)
%
%   Example
%   lcdInfo
%
%   See also

% Author: Bruno Direito (bruno.direito@uc.pt)
% Coimbra Institute for Biomedical Imaging and Translational Research, University of Coimbra.
% Created: 2022-01-27; Last Revision: 2022-01-27

lcd                 = struct();

lcd.pathToGreyData  = pathToGreyData;

% Pretest display lab95.
lcd.screenHeight    = 32.5; % Screen height (cm) 
lcd.screenWidth     = 52; % Screen width (cm).
lcd.viewingDistance = VIEWINGDISTANCE; %150; % Viewing Distance (cm).

lcd.bitres          = 8; % Bits.

end

