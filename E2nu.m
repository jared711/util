function nu = E2nu(E,e)
%E2nu converts eccentric anomaly in degrees to true anomaly in degrees
% 
% [nu] = E2nu(E, e)
% 
% Inputs:   E = [deg] (scalar) eccentric anomaly 
%           e = [] (scalar) eccentricity
% 
% Outputs:  nu = [deg] (scalar) true anomaly
% 
% See also: nu2E M2E E2M nu2M M2nu

% Author: Jared Blanchard 	Date: 2022/02/07 15:59:00 	Revision: 0.1 $

nu = 2*atand(sqrt((1+e)/(1-e))*tand(E/2));

while nu >= 360
    nu = nu - 360;
end
while nu < 0
    nu = nu + 360;
end

end