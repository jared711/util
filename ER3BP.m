function rvdot = ER3BP(f,rv)
% [rvdot] = ER3BP(f,rv)
% 
% Equations of motion for the three dimensional Elliptical Restricted 3 Body 
% Problem (ER3BP), broken down into a system of first order differential 
% equations.
% 
% Inputs:   f [rad] (scalar) true anomaly
%           rv [NON] (6x1) state vector [x y z xdot ydot zdot]' 
% 
% Outputs:  rvdot [NON] (6x1) state vector time derivative
% 
% Record of Revision
% Date          Programmer          Description of Changes
% 1/21/22       Jared T. Blanchard  I need to go through and double check this implementation. I threw it together today.
% 2/14/22       Jared T. Blanchard  fixed a bug today in the velocity equations (I was dividing the 2ydot and 2xdot terms by 1+ecosf. Also, the zdot term was missing the addition of z (X(3));
% 3/1/22        Jared T. Blanchard  made true anomaly, f, the independent variable

% access global variables
global mu e

if isempty(e)
    warning('No e value')
    e = 0;
end

% compute true anomaly 
% E = M2E(rad2deg(t), e);
% f = deg2rad(E2nu(E, e)); % true anomaly
% (approximate from series expansion)
% f = t + sin(t)*(2*e - e^3/4) + sin(2*t)*5*e^2/4 + sin(3*t)*13*e^3/12; % mean anomaly is simply time, since the mean motion is 1 rad/s and period is 2pi

% calculate cube of distances to both primaries
x = rv(1);  y = rv(2);  z = rv(3);
xdot = rv(4);   ydot = rv(5);
x1     = x + mu; % x component for PRIM
x2     = x - (1 - mu); %x component for SEC
r13      = (x1^2 + y^2 + z^2)^1.5; % PRIM
r23      = (x2^2 + y^2 + z^2)^1.5; % SEC

% assign time derivative state vector elements
rvdot    = zeros(6,1);
rvdot(1) = rv(4);
rvdot(2) = rv(5);
rvdot(3) = rv(6);
% Xdot(4) = (2*X(5) + X(1) - mu1*xx1/d3 - mu*xx2/r3)/(1+e*cos(f));
rvdot(4) = 2*ydot + (x - (1-mu)*x1/r13 - mu*x2/r23)/(1+e*cos(f));

% Xdot(5) = (- 2*X(4) + X(2) - mu1*X(2)/d3 - mu*X(2)/r3)/(1+e*cos(f));
rvdot(5) = - 2*xdot + (y - (1-mu)*y/r13 - mu*y/r23)/(1+e*cos(f));

% Xdot(6) = (-X(3)*e*cos(f) - mu1*X(3)/d3 - mu*X(3)/r3)/(1+e*cos(f));
rvdot(6) = -z + (z - (1-mu)*z/r13 - mu*z/r23)/(1+e*cos(f));

end