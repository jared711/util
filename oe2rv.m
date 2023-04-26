function [rv, rv_PF] = oe2rv(oe, gm)
%OE2RV Converts orbital elements to position and velocity
% 
% [rv, rv_PF] = OE2RV(oe, gm)
% 
% Inputs:   oe (6x1) orbital element vector
%               a (scalar) [km] semi-major axis
%               e (scalar) [] eccentricity
%               i (scalar) [rad] inclination
%               Omega (scalar) [rad] RAAN
%               omega (scalar) [rad] argument of periapsis
%               nu (scalar) [rad] true anomaly
%           gm (scalar) [km^3/s^2] gravitational parameter
% 
% Outputs:  rv (6x1) [km; km/s] cartesian state vector in ECI coord sys
%           rv_PF (6x1) [km; km/s] cartesian state perifocal coord sys
% system
% 
% See also: 

% Author: Jared Blanchard 	Date: 2023/04/07 21:52:30 	Revision: 0.1 $

a = oe(1);
e = oe(2);
i = oe(3);
Omega = oe(4);
omega = oe(5);
nu = oe(6);

r_norm = a*(1-e^2)/(1+e*cos(nu));           % [km] magnitude of position vector
r_PF = r_norm*[cos(nu); sin(nu); 0]; % [km] position vector in perifocal coordinate system
v_PF = a*(1-e^2)*sqrt(gm/(a*(1-e^2))^3)*[-sin(nu); (cos(nu) + e); 0]; % [km/s] velocity vector in perifocal coordinate frame
rv_PF = [r_PF; v_PF]; % full state in perifocal coordinates

R_PF2I = rotz(Omega)*rotx(i)*rotz(omega); % rotation matrix from perifocal to ECI 
R = [R_PF2I, zeros(3);
     zeros(3), R_PF2I]; % full rotation matrix

rv = R*rv_PF; % full state converted to body-centered inertial coordinate system
end
