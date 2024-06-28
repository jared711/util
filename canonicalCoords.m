function [xx_canonical] = canonicalCoords(xx)
%CANONICALCOORDS converts position and velocity coordinates to canonical
%coordinates in the CR3BP.
% 
% [xx_canonical] = CANONICALCOORDS(xx)
% 
% Inputs:   xx (Nx6) [units] states in position and velocity 
% 
% Outputs:  xx_canonical (Nx6) [units] states in canonical coordinates, p q
% 
% See also: 

% Author: Jared Blanchard 	Date: 2023/10/16 09:23:56 	Revision: 0.1 $

[N,n] = size(xx);
if n ~= 7 && n~= 6 && n~= 3 && n ~= 42
    if N == 7 || N == 6 || N == 3 || N == 42 
        xx = xx';
        n = N;
    else
        error("xx must be Nx7, Nx6, Nx3, or Nx42")
    end     
end
if n == 42
    xx = xx(:,37:42);
end

x = xx(:,1);    y = xx(:,2);    z = xx(:,3);
xdot = xx(:,4); ydot = xx(:,5); zdot = xx(:,6);
xx_canonical = [x, y, z, xdot-y, ydot+x, zdot];

end
