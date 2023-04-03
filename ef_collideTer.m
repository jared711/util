function [value,isterminal,direction] = ef_collideTer(t, x, theta0)
%EF_COLLIDETER Use as an event function in an integrator to determine if
%the particle has collided with the tertiary body
% 
% [value,isterminal,direction] = EF_COLLIDETER(t,x,theta0)
% 
% Inputs:   t (scalar) [] integration time
%           x (6x1) [] state
%           theta0 (scalar) [rad] initial angle of tertiary in rotating frame
% 
% Outputs:  value (scalar) [] once value changes sign, the event is called
%           isterminal (bool) [] stop integrating
%           direction (int) [] which direction the sign change occurs {0 either direction}
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/10/07 11:46:16 	Revision: 0.1 $

if nargin < 3;  theta0 = 0; end

global TER mu RUNIT
rval = TER.radius/RUNIT;
% compute radial velocity

a3          = TER.a;
mu3         = TER.mu;
n3          = sqrt((1+mu3)/a3^3);
theta       = theta0 + (n3-1)*t; % theta should be negative for the sun in motion

if TER.orbit_bary
    p = [a3*cos(theta);a3*sin(theta);0];
else
    p = [1-mu+a3*cos(theta);a3*sin(theta);0];
end

rrel        = x(1:3) - p;
rnorm       = norm(rrel);
value       = rnorm - rval;
direction   = 0;
isterminal  = 1;  % stop

end
