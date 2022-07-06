function nu = M2nu(M,e)
%M2nu converts mean anomaly in degrees to true anomaly in degrees
% 
% [nu] = M2nu(M, e)
% 
% Inputs:   M = [deg] (scalar) mean anomaly 
%           e = [] (scalar) eccentricity
% 
% Outputs:  nu = [deg] (scalar) true anomaly
% 
% See also: nu2M nu2E E2nu M2E E2M 

% Author: Jared Blanchard 	Date: 2022/02/07 15:33:00 	Revision: 0.1 $

E = M2E(M,e);
nu = E2nu(E, e);

end