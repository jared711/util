function [E] = nu2E(nu,e)
%NU2E converts true anomaly in degrees to eccentric anomaly in degrees
% 
% [E] = NU2E(nu, e)
% 
% Inputs:   nu = [deg] (scalar) true anomaly
%           e = [] (scalar) eccentricity
% 
% Outputs:  E = [rad] (scalar) eccentric anomaly
% 
% See also: E2nu M2E E2M nu2M M2nu

% Author: Jared Blanchard 	Date: 2022/02/07 13:58:54 	Revision: 0.1 $
%   Ported from work for AA279A

E = 2*atand(tand(nu/2)*sqrt((1-e)/(1+e)));

while E >= 360
    E = E - 360;
end

while E < 0
    E = E + 360;
end

end
