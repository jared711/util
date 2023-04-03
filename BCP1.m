function [rvdot] = BCP1(t, rv, mu, mu3, a3, theta0)
%BCP1 Bicircular Problem set in the rotating frame of the smaller bodies
%(e.g. Earth-Moon barycenter, with Sun in motion)
% 
% [rvdot] = BCP1(t, rv, mu, mu3, a3, theta0)
% 
% Inputs:   t (scalar) [] dimensionless time (also equal to angle of rotating frame w.r.t inertial frame in radians) 
%           rv (6x1) [] state [x,y,z,xdot,ydot,zdot]'
%           mu (scalar) [] mass parameter
%           mu3 (scalar) [] mass parameter of tertiary body
%           a3 (scalar) [] normalized semimajor axis of tertiary body
%           theta0 (scalar) [rad] initial phase angle of tertiary body
% 
% Outputs:  rvdot (6x1) [] state time derivative
% 
% See also: BCP2 CCP CR3BP PCR3BP

% Author: Jared Blanchard 	Date: 2022/10/05 13:42:40 	Revision: 0.1 $

if nargin < 6;  theta0 = 0; end

n3 = sqrt((1+mu3)/a3^3);
theta = theta0 + (n3-1)*t; % theta should be negative for the sun in motion

x = rv(1);  y = rv(2);  z = rv(3);
xdot = rv(4);   ydot = rv(5);
x3  = a3*cos(theta); % x component for TER
y3  = a3*sin(theta); % y component for TER
r13 = (  (x+mu)^2 +      y^2 + z^2)^1.5; % PRIM
r23 = ((x-1+mu)^2 +      y^2 + z^2)^1.5; % SEC
r33 = (  (x-x3)^2 + (y-y3)^2 + z^2)^1.5; % TER

rvdot = zeros(6,1);
rvdot(1:3) = rv(4:6);
rvdot(4) = -((1-mu)*(x+mu)/r13 + mu*(x-1+mu)/r23 + mu3*(x-x3)/r33 + mu3*cos(theta)/a3^2) + x + 2*ydot;
rvdot(5) = -((1-mu)*y     /r13 + mu*y       /r23 + mu3*(y-y3)/r33 + mu3*sin(theta)/a3^2) + y - 2*xdot;
rvdot(6) = -((1-mu)*z     /r13 + mu*z       /r23 + mu3*z     /r33);             

end