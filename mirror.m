function [xx_mirror] = mirror(xx)
%MIRROR mirror a trajectory about the xz plane
% 
% [xx_mirror] = MIRROR(xx)
% 
% Inputs:   xx (Nx6) [NON] trajectory 
% 
% Outputs:  xx_mirror (Nx6) [NON] mirrored trajectory 
% 
% See also: 

% Author: Jared Blanchard 	Date: 2023/10/12 11:09:36 	Revision: 0.1 $

xx_mirror = xx;
xx_mirror(:,2) = -xx(:,2);
xx_mirror(:,4) = -xx(:,4);
xx_mirror(:,6) = -xx(:,6);
end
