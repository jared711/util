function [r_ring] = circularRing(c,r,n,N,plot_flag)
%SPHERICALRING creates N points on a ring centered at c, with radius r, around normal
%vector n. 
% 
% r_ring = CIRCULARRING(c,r,n,N,plot_flag)
% 
% Inputs: 
%   c       [3X1] vector describing location of center of ring
%   r       (scalar) radius of ring
%   n       [3x1] vector normal to ring
%   N       (scalar) number of points on ring
%   plot_flag   (bool) flag for plotting [0]
% 
% Outputs: 
%   r_ring  [NX3] position vectors of all points on ring
% 
% See also: archimedesSphere sphericalDisc sphericalStrip sphericalRing

if nargin < 5;  plot_flag = 0;  end
if nargin < 4;  N = 100;        end
if nargin < 3;  n = [0;0;1];    end
if isrow(n);    n = n';         end
if nargin < 2;  r = 1;          end
if nargin < 1;  c = [0;0;0];    end
if isrow(c);    c = c';         end

theta = linspace(360/N,360,N)';
r_ring = r*[sind(theta)';
            cosd(theta)';
            zeros(1,N)];
        
dummy = [1;0;0];
if dot(n,dummy) > 0.9
    dummy = [0;1;0];
end
p = unit(cross(n,dummy));
q = unit(cross(n,p));
A = [p,q,n];
r_ring = (A*r_ring + c)';

if plot_flag == 1
    plot3(r_ring(:,1),r_ring(:,2),r_ring(:,3),'.')
    axis equal;     grid on
    xlabel('X');    ylabel('Y');    zlabel('Z')
end

% Author: Jared Blanchard 	Date: 2020/08/19 16:49:30 	Revision: 0.1 $

end