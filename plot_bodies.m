function [h] = plot_bodies(varargin)
%PLOT_BODIES Plots the primary and secondary bodies in the CR3BP rotating
%frame
% 
% [h] = PLOT_BODIES(varargin)
% 
% Inputs:   var_name (type) [units] description 
%           varargin
%               max_iter (int) [] maximum number of iterations {10}
%               epsilon (scalar) [] convergence criterion {1e-7}
%               plot_on (boolean) [] whether iterations should be plotted {0}
%               constraints (cell) [] constraints to be added {"x","y","z","xdot","zdot","T","rho","lambda"}
% 
% Outputs:  h (figure handle) [] output figure 
% 
% See also: 

% Author: Jared Blanchard 	Date: 2023/07/17 17:18:17 	Revision: 0.1 $
p = inputParser;
addOptional(p,'handlevis', 'off', @isstring)
addOptional(p,'N', 100, @isinteger)
addOptional(p,'col1', 'b')
addOptional(p,'col2', 'r')
addOptional(p,'r1', 1, @isnumeric)
addOptional(p,'r2', 0.1, @isnumeric)
addOptional(p,'mu', 0.5, @isnumeric)
% addOptional(p,'plot_on',false)
% addOptional(p,'constraints',["x","y","z","xdot","zdot","T","rho","lambda"], @isstring)
parse(p,varargin{:})
handlevis = p.Results.handlevis;
N = p.Results.N;
col1 = p.Results.col1;
col2 = p.Results.col2;
r1 = p.Results.r1;
r2 = p.Results.r2;
mu = p.Results.mu;

theta = linspace(0,2*pi,N); % angles of points on circl circle
% r = PRIM.radius/RUNIT; % radius of primary body in dimensionless units
fill(-mu+r1*cos(theta), r1*sin(theta),col1,'HandleVisibility',handlevis)
% r = PRIM.radius/RUNIT; % radius of secondary body in dimensionless units
fill(1-mu+r2*cos(theta), r2*sin(theta),col2,'HandleVisibility',handlevis)

end
