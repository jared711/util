function [xx] = phaseSpace(xx_can)
%PHASESPACE converts from canonical coordinates back into position and
%velocity
% 
% [xx] = PHASESPACE(xx_can)
% 
% Inputs:   xx_can (Nx6) [units]  
% 
% Outputs:  xx (Nx6) [units]  
% 
% See also: 

% Author: Jared Blanchard 	Date: 2023/10/16 11:53:27 	Revision: 0.1 $

[N,n] = size(xx_can);
if n ~= 7 && n~= 6 && n~= 3 && n ~= 42
    if N == 7 || N == 6 || N == 3 || N == 42 
        xx_can = xx_can';
        n = N;
    else
        error("xx must be Nx7, Nx6, Nx3, or Nx42")
    end     
end
if n == 42
    xx_can = xx_can(:,37:42);
end

q1 = xx_can(:,1);   q2 = xx_can(:,2);   q3 = xx_can(:,3);
p1 = xx_can(:,4);   p2 = xx_can(:,5);   p3 = xx_can(:,6);

x = q1;
y = q2;
z = q3;
xdot = p1 + q2;
ydot = p2 - q1;
zdot = p3;

xx = [x,y,z,xdot,ydot,zdot];

end
