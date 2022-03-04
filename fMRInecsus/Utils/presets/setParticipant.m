function p = setParticipant(ID, NT, GT, GNT)
%SETPARTICIPANT  This function creates a struct with information about the participant. Participants.Psychophysic: contains the contrast values obtained in psychophysical task
%   output = setParticipant(input)
%
%   Example
%   setParticipant
%
%   See also

% Author: Bruno Direito (bruno.direito@uc.pt)
% Coimbra Institute for Biomedical Imaging and Translational Research, University of Coimbra.
% Created: 2022-03-04; Last Revision: 2022-03-04


p.ID=ID;

p.psychophysic.NT=NT;
p.psychophysic.GT=GT;
p.psychophysic.GNT=GNT;

end

