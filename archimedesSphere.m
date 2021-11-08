function [r_sphere] = archimedesSphere(c,r,N,plot_flag)
%ARCHIMEDESSPHERE generates N random uniformly distributed points on the
%surface of a sphere of radius r centered at c.
% 
% [r_sphere] = ARCHIMEDESSPHERE(c,r,N,plot_flag)
% 
% Inputs:
%   c           (3X1) position of center of sphere [0;0;0]
%   r           (scalar) radius of sphere [1]
%   N       	(scalar) number of points on sphere [100]
%   plot_flag   (bool) flag for plotting [0]
% 
% Outputs
%   r_sphere    [NX3] points on sphere
% 
% See also: sphericalDisc randomUniformSphereVolume

if nargin < 4;  plot_flag = 0;  end
if nargin < 3;  N = 100;        end
if nargin < 2;  r = 1;          end
if nargin < 1;  c = [0;0;0];    end
if isrow(c);    c = c';         end

wpos = 360;                     % circumference of projected cylinder (width of rectangle)
hpos = 2;                   % height of projected cylinder (rectangle)
xpos = wpos*rand(N,1);     % uniform sampling along width of rectangle
ypos = hpos*rand(N,1);     % uniform sampling along height of rectangle
lon = xpos;                     % longitude from Saturnfacing meridian [deg]
lat = -asind(1 - hpos + ypos);  % latitude measured from equator (south pole)
r_sphere = rlatlon2cart([r*ones(N,1),lat,lon], c');

if plot_flag
    plot3(r_sphere(:,1),r_sphere(:,2),r_sphere(:,3),'.')
end

% Author: Jared Blanchard 	Date: 2020/07/23 19:52:51 	Revision: 0.1 $



end
