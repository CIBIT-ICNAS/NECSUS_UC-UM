function [ gabor ]=gaborInfo(sfrq)
%GABORINFO  sets gabor info into a structure
%   gabor = gaborInfo(sfrq) creates a structure with gabor info.
%
%   Example
%   gaborInfo
%
%   See also

% Author: Bruno Direito (bruno.direito@uc.pt)
% Coimbra Institute for Biomedical Imaging and Translational Research, University of Coimbra.
% Created: 2022-01-27; Last Revision: 2022-01-27

gabor=struct();

gabor.gaborDimDegree=12; % Dimension of the region where will draw the Gabor in degrees

gabor.phase=0; % spatial phase
gabor.angle=0; %the optional orientation angle in degrees (0-360)
gabor.aspectratio=1.0; % Defines the aspect ratio of the hull of the gabor
gabor.desiredSF=sfrq; % Desired Spatial Frequency in cpd.

end
