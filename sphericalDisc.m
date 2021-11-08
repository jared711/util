function [r_disc] = sphericalDisc(c,r,N,alpha,plot_flag)
%SPHERICALDISC creates a disc projected onto the surface of a sphere using
%Archimedes projection
% 
% r_disc = SPHERICALDISC(c,r,N,alpha,plot_flag) 
% 
% Inputs:
%   c       [3X1] vector describing location of center of sphere
%   r       [3X1] vector describing location of center of disc w.r.t center
%                   of sphere (magnitude is radius of sphere)
%   N       (scalar) number of points on disc
%   alpha   (scalar) half angle of spherical cone (theta = 90 would
%                   describe a complete hemisphere)
%   plot_flag   (bool) flag for plotting [0]

% Outputs:
%   r_disc  [NX3] position vectors of all points on spherical disc
%
% See also: archimedesSphere sphericalRing sphericalStrip

if nargin < 5;  plot_flag = 0;  end
if nargin < 4;  alpha = 10;     end
if alpha > 180; error('alpha should be less than 180 degrees'); end
if nargin < 3;  N = 100;        end
if nargin < 2;  r = [0;0;1];    end
if isrow(r);    r = r';         end
if nargin < 1;  c = [0;0;0];    end
if isrow(c);    c = c';         end

wpos = 360;                     % circumference of projected cylinder (width of rectangle)
hpos = (1-cosd(alpha));         % height of projected cylinder (rectangle)
xpos = wpos*rand(N,1);     % uniform sampling along width of rectangle
ypos = hpos*rand(N,1);     % uniform sampling along height of rectangle
lon = xpos;                     % longitude from Saturnfacing meridian [deg]
lat = asind(1 - hpos + ypos);  % latitude measured from equator (south pole)

r_disc = rlatlon2cart([norm(r)*ones(N,1),lat,lon]); % points centered at the origin

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
r_disc = (A*r_disc' + c)';

if plot_flag == 1
    plot3(r_disc(:,1),r_disc(:,2),r_disc(:,3),'.')
    axis equal;     grid on
    xlabel('X');    ylabel('Y');    zlabel('Z')
end

% Author: Jared Blanchard 	Date: 2020/07/23 12:52:52 	Revision: 0.1 $

end
