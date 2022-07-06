function [E] = M2E(M, e, tol)
%M2E Converts true anomaly in degrees to eccentric anomaly in degrees using
% Kepler's equation
% 
% [E] = M2E(M, e, tol)
% 
% Inputs:   M = [deg] (scalar) mean anomaly 
%           e = [] (scalar) eccentricity
%           tol [] (scalar) tolerance for newton's method {1e-10}
% 
% Outputs:  E = [deg] (scalar) eccentric anomaly
% 
% See also: E2M nu2E E2nu nu2M M2nu

% Author: Jared Blanchard 	Date: 2022/02/07 16:17:59 	Revision: 0.1 $

if nargin < 3;  tol = 1e-10;    end

E = M; %Initial guess
delta = -(E - e*sind(E) - M)/(1-e*cosd(E));
iterations = 0;
i_max = 100;
while abs(delta) > abs(tol) && iterations < i_max
    E = E + delta;
    delta = -(E - e*sind(E) - M)/(1-e*cosd(E));
    iterations = iterations + 1;
end

end
