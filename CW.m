function [rvdot] = CW(t, rv, n)
%CW Clohessy-Wiltshire equations of motion for orbtial relative motion
% 
% [rvdot] = CW(rv, n)
% 
% Inputs:   rv [km; km/s] (6x1) initial state
%           n [rad/s] orbital rate of target body
% 
% Outputs:  rvdot [km/s; km/s^2] (6x1) time derivative of state
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/05/20 16:05:33 	Revision: 0.1 $

if nargin < 3;  n = 1;  end

   x = rv(1);      y = rv(2);      z = rv(3);
xdot = rv(4);   ydot = rv(5);   zdot = rv(6);
rvdot = zeros(6,1);
rvdot(1:3) = [xdot; ydot; zdot];
rvdot(4) = 3*n^2*x + 2*n*ydot;
rvdot(5) = -2*n*xdot;
rvdot(6) = -n^2*z;

end
