function [rs] = sphereMarsaglia(n,N,r,plot_flag)
%SPHEREMARSAGLIA computes an n-sphere of radius r by using the algorithm
% proposed by Marsaglia, G. (1972). "Choosing a Point from the Surface of a
% Sphere". Annals of Mathematical Statistics. 43 (2): 645–646. 
% doi:10.1214/aoms/1177692644.
% 
% [rs] = SPHEREMARSAGLIA(n,N,r,plot_flag)
% 
% Inputs:   n (integer) dimension of sphere {2}
%           N (integer) number of points {1000}
%           r (scalar) radius of n-sphere {1}
%           plot_flag (bool) plot points? {0}
% 
% Outputs:  rs (nx3) points randomly distributed on sphere surface
% 
% See also: desernoSphere, archimedesSphere

% Author: Jared Blanchard 	Date: 2022/08/18 10:31:56 	Revision: 0.1 $

if nargin < 4;  plot_flag = 0;  end
if nargin < 3;  r = 1;          end
if nargin < 2;  N = 1000;       end
if nargin < 1;  n = 2;          end

if n < 1;   error('n must be a positive integer');  end
if N < 1;   error('N must be a positive integer');  end

rs = randn(n+1,N);
radii = vecnorm(rs);
rs = r*rs./radii;
if plot_flag
    if n == 2
        plot3(rs(1,:),rs(2,:),rs(3,:),'.')
    elseif n == 1
        plot(rs(1,:),rs(2,:),'.')
    else
        warning('cannot plot hyperspheres')
    end
end
end
