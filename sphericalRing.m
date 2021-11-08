function [r_ring] = sphericalRing(c,r,N,alpha,plot_flag)
%SPHERICALRING creates a ring projected onto the surface of a sphere with
%points spaced evenly along it
% 
% r_ring = SPHERICALRING(c,r,N,alpha,plot_flag)
% 
% Inputs: 
%   c       [3X1] vector describing location of center of sphere
%   r       [3X1] vector describing location of center of ring w.r.t center
%                   of sphere (magnitude is radius of sphere)
%   N       (scalar) number of points on ring
%   alpha   (scalar) half angle of spherical cone (theta = 90 would
%                   describe a complete hemisphere)
%   plot_flag   (bool) flag for plotting [0]
% 
% Outputs: 
%   r_ring  [NX3] position vectors of all points on spherical ring
% 
% See also: archimedesSphere sphericalDisc sphericalStrip

if nargin < 5;  plot_flag = 0;  end
if nargin < 4;  alpha = 10;     end
if alpha > 180; error('alpha should be less than 180 degrees'); end
if nargin < 3;  N = 100;        end
if nargin < 2;  r = [0;0;1];    end
if isrow(r);    r = r';         end
if nargin < 1;  c = [0;0;0];    end
if isrow(c);    c = c';         end

lat = 90 - alpha;
lon = linspace(360/N,360,N)';
r_ring = rlatlon2cart([norm(r)*ones(N,1),lat*ones(N,1),lon]); % points centered at the origin

dummy = [1;0;0];
r = r/norm(r);
if dot(r,dummy) > 0.9
    dummy = [0;1;0];
end
p = cross(r,dummy);
p = p/norm(p);
q = cross(r,p);
q = q/norm(q);
A = [p,q,r];
r_ring = (A*r_ring' + c)';

if plot_flag == 1
    plot3(r_ring(:,1),r_ring(:,2),r_ring(:,3),'.')
    axis equal;     grid on
    xlabel('X');    ylabel('Y');    zlabel('Z')
end

% Author: Jared Blanchard 	Date: 2020/08/19 16:49:30 	Revision: 0.1 $

end