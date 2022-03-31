function [rvdot] = CR3BP(t, rv, mu)
%CR3BP equations of motion for the circular restricted three-body problem
% 
% [rvdot] = CR3BP(t, rv, mu)
% 
% Inputs:   t [] (scalar) non-dimensional time
%           rv [] (6x1) state [x,y,z,xdot,ydot,zdot]'
%           mu [] (scalar) mass parameter
% 
% Outputs:  rvdot [] (6x1) state time derivative
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/03/01 10:46:05 	Revision: 0.1 $

if nargin < 3;  global mu;  end

x = rv(1);  y = rv(2);  z = rv(3);
xdot = rv(4);   ydot = rv(5);
x1  = x + mu; %x component for PRIM
x2  = x - (1 - mu); %x component for SEC
r13 = (x1^2 + y^2 + z^2)^1.5; % PRIM
r23 = (x2^2 + y^2 + z^2)^1.5; % SEC

rvdot = zeros(6,1);
rvdot(1:3) = rv(4:6);
rvdot(4) =  2*ydot + x - (1-mu)*x1/r13 - mu*x2/r23;
rvdot(5) = -2*xdot + y - (1-mu)*y/r13  - mu*y/r23;
rvdot(6) =             - (1-mu)*z/r13  - mu*z/r23; 

end
