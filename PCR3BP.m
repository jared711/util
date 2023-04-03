function [rvdot] = PCR3BP(t, rv, mu)
%PCR3BP equations of motion for the planar circular restricted three-body problem
% 
% [rvdot] = PCR3BP(t, rv, mu)
% 
% Inputs:   t [] (scalar) non-dimensional time
%           rv [] (4x1) state [x,y,xdot,ydot]'
%           mu [] (scalar) mass parameter
% 
% Outputs:  rvdot [] (4x1) state time derivative
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/09/29 16:09:07 	Revision: 0.1 $

if nargin < 3;  global mu;  end

x = rv(1);  y = rv(2);
xdot = rv(3);   ydot = rv(4);
x1  = x + mu; %x component for PRIM
x2  = x - (1 - mu); %x component for SEC
r13 = (x1^2 + y^2)^1.5; % PRIM
r23 = (x2^2 + y^2)^1.5; % SEC

rvdot = zeros(4,1);
rvdot(1:2) = rv(3:4);
rvdot(3) =  2*ydot + x - (1-mu)*x1/r13 - mu*x2/r23;
rvdot(4) = -2*xdot + y - (1-mu)*y/r13  - mu*y/r23;

end
