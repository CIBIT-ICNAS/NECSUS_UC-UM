function [ gabor ]=gaborInfo(spatFreqCdM)
%GABORINFO  creates a structure with gabor info.
%   output = gaborInfo(input)
%
%   Example
%   gaborInfo
%
%   See also

% Author: Bruno Direito (bruno.direito@uc.pt)
% Coimbra Institute for Biomedical Imaging and Translational Research, University of Coimbra.
% Created: 2022-03-04; Last Revision: 2022-03-04

gabor=struct();

gabor.gaborDimDegree=12; %750; % Dimension of the region where will draw the Gabor in pixels

gabor.phase=0; % spatial phase
gabor.angle=0; %the optional orientation angle in degrees (0-360)
gabor.aspectratio=1.0; % Defines the aspect ratio of the hull of the gabor
gabor.spatFreqCdM=spatFreqCdM; % Desired Spatial Frequency in cpd.



end
