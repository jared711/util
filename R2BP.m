function [xdot] = R2BP(t, x, mu)
%R2BP equations of motion for Restricted two-body problem
% 
% [xdot] = R2BP(t, x, mu)
% 
% Inputs:
%       t [sec] (scalar) time
%       x [km; km/s] (6x1) state
%       mu [km^3/s^2] (scalar) GM value
% 
% Outputs: 
%       xdot [km/s; km/s^2] state time derivative
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/06/15 15:46:58 	Revision: 0.1 $

if isrow(x);    x = x'; end


xdot = zeros(6,1);
xdot(1:3) = x(4:6);
r = x(1:3);
xdot(4:6) = -mu/norm(r)^2*unit(r);

end
