function [r_strip] = sphericalStrip(c,r,N,alpha,beta,plot_flag)
%SPHERICALSTRIP creates a strip projected onto the surface of a sphere using
%Archimedes projection
% 
% r_disc = SPHERICALSTRIP(c,r,N,alpha,plot_flag) 
% 
% Inputs:
%   c       [3X1] vector describing location of center of sphere
%   r       [3X1] vector describing location of center of disc w.r.t center
%                   of sphere (magnitude is radius of sphere)
%   N       (scalar) number of points on disc
%   alpha   (scalar) starting angle [0]
%   beta    (scalar) ending angle [180]
%   plot_flag   (bool) flag for plotting [0]

% Outputs:
%   r_disc  [NX3] position vectors of all points on spherical disc
%
% See also: archimedesSphere sphericalDisc

if nargin < 6;  plot_flag = 0;  end
if nargin < 5;  beta = 180;     end
if nargin < 4;  alpha = 0;     end
if alpha > 180; error('alpha should be less than 180 degrees'); end
if nargin < 3;  N = 100;        end
if nargin < 2;  r = [0;0;1];    end
if isrow(r);    r = r';         end
if nargin < 1;  c = [0;0;0];    end
if isrow(c);    c = c';         end
if beta < alpha;    error("beta must be greater than alpha");   end

wpos = 360;                     % circumference of projected cylinder (width of rectangle)
a = (1-cosd(alpha));         % height of projected cylinder (rectangle)
b = (1-cosd(beta));
xpos = wpos*rand(N,1);     % uniform sampling along width of rectangle
ypos = a+(b-a)*rand(N,1);  % uniform sampling along height of rectangle
lon = xpos;                     % longitude from Saturnfacing meridian [deg]
lat = asind(1-ypos);  % latitude measured from equator (south pole)

r_strip = rlatlon2cart([norm(r)*ones(N,1),lat,lon]); % points centered at the origin

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
r_strip = (A*r_strip' + c)';

if plot_flag == 1
    plot3(r_strip(:,1),r_strip(:,2),r_strip(:,3),'.')
    axis equal;     grid on
    xlabel('X');    ylabel('Y');    zlabel('Z')
end

% Author: Jared Blanchard 	Date: 2020/08/18 16:37:16 	Revision: 0.1 $

end