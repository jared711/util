function [xyz_hem, N_new] = desernoHemisphere(N, r, c, n, plot_flag)
%DESERNOHEMISPHERE Summary of this function goes here
% 
% [xyz_hem, N_new] = DESERNOHEMISPHERE(N, r, c, n)
% 
% Inputs:
%   N           [1x1] Number of desired points for somewhat evenly spaced hemisphere
%   r           (scalar) radius of sphere
%   c           [3x1] center of sphere
%   n           [3x1] A vector about which the desired hemisphere will be centered
%   plot_flag   (bool) flag for plotting [0]
% 
% Outputs:
%   xyz_hem  [3xN_new] Matrix of positions of each point in the hemisphere
%   N_new    [1x1] Number of points in the sphere
% 
% See also: desernoSphere

% Author: Jared Blanchard 	Date: 2020/08/18 21:13:56 	Revision: 0.1 $
% Adapted from getHemisphere.jl by Lucas Bury luke.bury@colorado.edu

if nargin < 5;  plot_flag = 0;end
if nargin < 4;  n = [0;0;1];    end
if isrow(n);    n = n';         end
if nargin < 3;  c = [0;0;0];    end
if isrow(c);    c = c';         end
if nargin < 2;  r = 1;          end
if nargin < 1;  N = 25;         end

[xyz_Sphere, ~] = desernoSphere(N*2,plot_flag);

% Indices of points with a 'z' value >= 0
idx = xyz_Sphere(:,3) >= 0;

%  Use logical indexing to grab all points with a 'z' >= 0
xyz_hem = r*xyz_Sphere(idx,:);
N_new = size(xyz_hem, 1);

%  If n is in the -z axis, just flip the signs on the existing hemisphere
%  In desernoSphere, the pattern is centered around the 'z' axis
n_old = [0; 0; 1];

% Turn input vector to unit vector
n = unit(n);

if n == n_old
elseif n == -n_old
    for i = 1:N_new
        xyz_hem(i,:) = [xyz_hem(i,1), xyz_hem(i,2),-xyz_hem(i,3)];
    end
else
    % Compute the rotation matrix to properly align the new hemisphere
    % Algorithm to compute a rotation matrix between two vectors
    v = cross(n_old, n);
    skewSymmetricMat = [0 -v(3) v(2); v(3) 0 -v(1); -v(2) v(1) 0];
    R_old2new = [1 0 0; 0 1 0; 0 0 1] + skewSymmetricMat + skewSymmetricMat*skewSymmetricMat*(1 / (1 + dot(n_old,n)));

    % Rotate old hemisphere to new position, centered about n
    for i = 1:N_new
        xyz_hem(i,:) = (R_old2new * xyz_hem(i,:)')';
    end
end

xyz_hem = xyz_hem + c';

if plot_flag
    plot3(xyz_hem(:,1),xyz_hem(:,2),xyz_hem(:,3),'.')
end

end