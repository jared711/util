function [oe] = rv2oe(rv, gm)
%RV2OE2 Summary of this function goes here
% 
% [oe] = RV2OE(rv, gm)
% 
% Inputs:   rv (6x1) [km, km/s] cartesian state vector 
%           gm (scalar) [km^3/s^2] standard gravitational parameter
% 
% Outputs:  oe (6x1) orbital element vector
%               a (scalar) [km] semi-major axis
%               e (scalar) [] eccentricity
%               i (scalar) [rad] inclination
%               Omega (scalar) [rad] RAAN
%               omega (scalar) [rad] argument of periapsis
%               nu (scalar) [rad] true anomaly
% 
% See also: 

% Author: Jared Blanchard 	Date: 2023/04/07 22:22:44 	Revision: 0.1 $

if ~iscolumn(rv) % make sure rv is a colmn vector
    rv = rv';
end

r = rv(1:3);    % [km] position vector
v = rv(4:6);    % [km/s] velocity vector

h = cross(r,v); % [km^2/s] specific angular momentum
i = atan2(norm(h(1:2)),h(3)); % [rad] inclination

if i == 0 || i == pi
    Omega = NaN;
else
    Omega = atan2(h(1),-h(2));
end

p = norm(h)^2/gm; % [km] semilatus rectum
a = (2/norm(r) - norm(v)^2/gm)^(-1); % [km] semimajor axis
e = sqrt(1 - p/a); % [] eccentricity

if a < 0
    nu = NaN;
    omega = NaN;
else
    n = sqrt(gm/a^3);   % [rad/s] mean motion
    E = atan2((r'*v)/(n*a^2),(1-norm(r)/a)); % [rad] eccentric anomaly
    nu = E2nu(E,e);     % [rad] true anomaly
    u = atan2(r(3)/sin(i),r(1)*cos(Omega) + r(2)*sin(Omega)); % [rad] argument of latitude
    omega = u-nu;       % [rad] argument of periapsis
end

nu = wrapTo2Pi(nu);
omega = wrapTo2Pi(omega);

oe = [a; e; i; Omega; omega; nu];
end

