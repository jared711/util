function [xyz_Sphere, N_new] = desernoSphere(N, plot_flag)
%DESERNOSPHERE Summary of this function goes here
% 
% [xyz_Sphere, N_new] = DESERNOSPHERE(N, plot_flag)
% 
% Inputs:
%   N_desired   [1x1] Number of desired points for somewhat evenly spaced hemisphere
%   plot_flag   (bool) flag for plotting [0]
% 
% Outputs: 
%   xyz_unitHemisphere  [3xN_new] Matrix of positions of each point in the hemisphere
%   N_new               [1x1] Number of points in the sphere
% 
% See also: desernoHemisphere

% Author: Jared Blanchard 	Date: 2020/08/18 17:53:46 	Revision: 0.1 $
% Adapted from getSphere.jl by Lucas Bury luke.bury@colorado.edu

if nargin < 2;  plot_flag = 0;  end
if nargin < 1;  N = 50;         end

area = 4*pi/N;
distance = sqrt(area);

M_theta = round(pi/distance);

d_theta = pi/M_theta;

d_phi = area/d_theta;

N_new = 0;
xs = [];
ys = [];
zs = [];
for m = 0:(M_theta-1)
    theta = pi*(m+0.5)/M_theta;
    M_phi = round(2*pi*sin(theta)/d_phi); % not exact
    for n = 0:(M_phi-1)
        Phi = 2*pi*n/M_phi;
        N_new = N_new + 1;
        xs = [xs; sin(theta)*cos(Phi)];
        ys = [ys; sin(theta)*sin(Phi)];
        zs = [zs; cos(theta)];
    end
end

xyz_Sphere = [xs, ys, zs];

if plot_flag
    plot3(xs, ys, zs,'.')
end

end
