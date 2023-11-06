function [rv_dot] = ephemDynamics(t, rv, options)
%EPHEMDYNAMICS Computes the time derviative of an interial state with
%respect to a central body by taking into account the gravity of the
%central body as well as other perturbing bodies as defined in options.
%Note that we assume the spacecraft mass is zero.
% 
% [rv_dot] = EPHEMDYNAMICS(t, rv, options)
% 
% Inputs:   t (scalar) integration time used by integrator algorithm
%           rv (6x1) [km; km/s] spacecraft state with respect to central body in inertial frame
%           options
%               et0 (scalar) [sec] initial ephemeris time as used by SPICE 
%               frame (string) inertial reference frame as used by SPICE
%               bodies (1xN string array) perturbing bodies
%               observer (string) central body
%
% Outputs: rv_dot (6x1) [km/s; km/s^2] spacecraft state time derivative in inertial frame
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/08/01 16:06:24 	Revision: 0.1 $

et = options.et0 + t;
r_1_sc = rv(1:3); % vector pointing from central body to spacecraft 
r_1_sc = r_1_sc(:); % make sure it's a column vector 

a = zeros(3,1); % initialize as column vector
gm1 = cspice_bodvrd(options.observer, 'GM', 1); % standard gravitational parameter of central body
a(:) = -gm1*r_1_sc/(norm(r_1_sc)^3); % Acceleration from central body (make sure it's still a column vector)
for body = options.bodies
    r_1_i = cspice_spkpos(body{1}, et, options.frame, 'NONE', options.observer); % vector pointing from central body to ith perturbing body
    if norm(r_1_i) == 0;    error("The central body should not be included in the perturbing bodies array");  end
 
    r_sc_i = r_1_i - r_1_sc; % vector pointing from ith perturbing body to spacecraft
    gm_i = cspice_bodvrd(body{1}, 'GM', 1 ); % standard gravitational parameter of perturbing body
    a(:) = a(:) + gm_i*( r_sc_i/norm(r_sc_i)^3 - r_1_i/norm(r_1_i)^3 ); % acceleration from perturbing body (direct and indirect terms)
end

rv_dot = zeros(6,1); % initialize as a column vector
rv_dot(1:3) = rv(4:6); % velocity
rv_dot(4:6) = a(:); % acceleration

end
