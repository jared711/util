function M = nu2M(nu,e)
%nu2M converts true anomaly in degrees to mean anomaly
% 
% [M] = nu2M(nu, e)
% 
% Inputs:   nu = [deg] (scalar) true anomaly 
%           e = [] (scalar) eccentricity
% 
% Outputs:  M = [deg] (scalar) mean anomaly
% 
% See also: M2nu nu2E E2nu M2E E2M

% Author: Jared Blanchard 	Date: 2022/02/07 15:33:00 	Revision: 0.1 $

E = nu2E(nu,e);
M = E2M(E, e);

end