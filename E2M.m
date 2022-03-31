function [M] = E2M(E,e)
%E2M Converts eccentric anomaly in degrees to mean anomaly in degrees
% 
% [M] = E2M(E, e)
% 
% Inputs:   E = [deg] (scalar) eccentric anomaly 
%           e = [] (scalar) eccentricity
% 
% Outputs:  M = [deg] (scalar) mean anomaly
% 
% See also: M2E nu2E E2nu nu2M M2nu

% Author: Jared Blanchard 	Date: 2022/02/07 16:15:43 	Revision: 0.1 $

M = E - e*sind(E);

end
