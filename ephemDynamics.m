function [rv_dot] = ephemDynamics(t, rv, options)
%EPHEMDYNAMICS Summary of this function goes here
% 
% [rv_dot] = EPHEMDYNAMICS(et, rv, options)
% 
% Inputs:   t (scalar) integration time used by integrator algorithm
%           rv (6x1) [km; km/s] spacecraft state
%           options
%               et0 (scalar) [sec] initial ephemeris time as used by SPICE 
%               frame (string)
%               bodies (1xN string array) 
%               observer
%
% Outputs: rv_dot (6x1) [km/s; km/s^2] spacecraft state time derivative
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/08/01 16:06:24 	Revision: 0.1 $

et = options.et0 + t;
r_sc = rv(1:3);

a = zeros(3,1);
for body = options.bodies
    r_body = cspice_spkpos(body{1}, et, options.frame, 'NONE', options.observer);
    r_i = r_sc - r_body;
    gm = cspice_bodvrd(body{1}, 'GM', 1 );
    a = a + (-gm/(norm(r_i)^3))*r_i;
end

rv_dot = zeros(6,1);
rv_dot(1:3) = rv(4:6);
rv_dot(4:6) = a;

end
