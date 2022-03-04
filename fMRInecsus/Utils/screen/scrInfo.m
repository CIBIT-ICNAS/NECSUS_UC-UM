function [ scr ] = scrInfo(VIEWINGDISTANCE)
% lcdInfo sets lcd info into a structure
%   lcd = lcdInfo() creates a structure with lcd info.
%
% 

scr=struct();

% MR lcd size.
% % % Screen height (cm).
% % scr.screenHeight=39.5; 
% % % Screen width (cm).
% % scr.screenWidth=70; 
    
scr.screenHeight=25.9; % Screen height (cm) nb. 34.7.
scr.screenWidth=54.6; % Screen width (cm).

% Viewing Distance (cm).
scr.viewingDistance=VIEWINGDISTANCE; 

% Bits.
scr.bitres=8; 


end

