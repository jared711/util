function [a,e,i,OMEGA,omega,nu,ang,ME] = cart2oe(rv_ECI,mu,ang_unit)
%CART2OE converts cartesian coordinates in inertial frame to orbital
%elements. This function is able to handle any orbit type , including 
% equatorial and circular orbits. The output extra_angle will output the
% following values for each orbit type
% 1) Elliptical equatorial
% Longitude of periapsis , ang = Pi = OMEGA + omega
% 2) Circular inclined
% Argument of latitude , ang = u = omega + nu
% 3) Circular equatorial
% True latitude , ang = l = OMEGA + omega + nu
% Otherwise , ang will be undefined ( NaN )
% 
% [a, e, i, OMEGA, omega, nu, ang, ME] = CART2OE_D(rv_ECI, mu, ang_unit)
% 
% Inputs:   rv_ECI = [km; km/s] (6x1) state vector in ECI frame
%           mu = [km^3/s^2] (scalar) gravitational parameter of body
%           ang_unit [] (string) 'rad' or 'deg' {'deg'}
% 
% Outputs:  a = [km] (scalar) semimajor axis
%           e = [] (scalar) eccentricity
%           i = [deg/rad] (scalar) inclination
%           OMEGA = [deg/rad] (scalar) right ascension of the ascending node
%           omega = [deg/rad] (scalar) argument of periapsis
%           nu = [deg/rad] (scalar) true anomaly
%           ang [deg/rad] (scalar) extra angle for special cases
%           ME = [km^2/s^2] (scalar) mechanical energy
% 
% See also: 

% Author: Jared Blanchard 	Date: 2021/02/15 09:31:37 	Revision: 0.1 $
% Adapted from ECI2OE.m used in Stanford's AA279A course.

if nargin < 3;  ang_unit = 'deg';       end
if nargin < 2;  global mu;              end
if isempty(mu); error("no mu value");   end
if isrow(rv_ECI);   rv_ECI = rv_ECI';    end
if ~iscolumn(rv_ECI);    error('rv_ECI should be a vector');  end

r_ECI = rv_ECI(1:3);
v_ECI = rv_ECI(4:6);
r = norm(r_ECI);
v = norm(v_ECI);
% Create all necessary vectors
hVec = cross(r_ECI, v_ECI);
h = norm(hVec);
nVec = cross([0, 0, 1], hVec);
n = norm(nVec);
eVec = (1/mu)*((v^2 - mu/r)*r_ECI - dot(r_ECI, v_ECI)*v_ECI);
e = norm(eVec);
% Compute the size of the orbit
ME = 0.5* v^2 - mu/r;
if e ~= 1
    a = -mu/(2*ME);
    p = a*(1 - e ^2);
else
    a = Inf ;
    p = h^2/mu;
end
% Compute the orientation of the orbit
i = acosd (hVec(3)/h);
OMEGA = acosd (nVec(1)/n);
omega = acosd(dot(nVec, eVec)/(n*e));
nu = acosd(dot(eVec, r_ECI)/(e*r));
% Place angles in the correct domains
if nVec (2) < 0
    OMEGA = 360 - OMEGA;
end
if eVec (3) < 0
    omega = 360 - omega;
end
if dot(r_ECI, v_ECI) < 0
    nu = 360 - nu ;
end
% Account for any special cases
if (i == 0 || i == 180) && e ~= 0 % Elliptical equatorial
    % Provide the longitude of periapsis (PI = Om + w)
    ang = acosd ( eVec (1) /e);
if eVec (2) < 0
    ang = 360 - ang;
end
elseif (i ~= 0 && i ~= 180) && e == 0 % Circular inclined
    % Provide the argument of latitude (u = w + anom )
    ang = acosd ( dot (nVec , r_ECI )/(n*r));
if r_ECI (3) < 0
    ang = 360 - ang;
end
elseif (i == 0 || i == 180) && e == 0 % Circular equatorial
    % Provide the true latitude ( l = Om + w + anom )
    ang = acosd ( r_ECI (1) /r);
if r_ECI (2) < 0
    ang = 360 - ang;
end
else
    % Default output for ang
    ang = NaN ;
end

switch string(ang_unit)
    case "deg"
    case "rad"
        i = deg2rad(i);
        OMEGA = deg2rad(OMEGA);
        omega = deg2rad(omega);
        nu = deg2rad(nu);
        ang = deg2rad(ang);
    otherwise
        error("ang_unit should be 'rad' or 'deg'")
end

end