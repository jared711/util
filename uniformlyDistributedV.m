function [vs] = uniformlyDistributedV(r,C,el_min,el_max,N,n,plot_flag,mu)
%UNIFORMLYDISTRIBUTEDV Generates velocity vectors that are randomly
%distributed from a single emanating point using Archimedes' theorem. The
%velocity vectors are constrained to yield the Jacobi constant C when
%paired with the position r.
% 
% [vs] = UNIFORMLYDISTRIBUTEDV(r, C, el_min, el_max, N, n, plot_flag)
% 
% Inputs: 
%   r           [3X1] position vector from which velocities will spread
%   C           (scalar) Jacobi constant
%   el_min      (scalar) minimum elevation in degrees
%   el_max      (scalar) maximum elevation in degrees [0]
%   N           (scalar) number of velocities to generate [100]
%   n           [3X1] normal vector from surface of planet at r
%   plot_flag   (bool) flag for plotting [0]
%   mu          (scalar) gravitational parameter
% 
% Outputs: 
%   vs          [NX3] uniformly sampled velocities
% 
% See also: 

if ~iscolumn(r);    r = r';         end
if nargin < 8;  global mu;          end
if nargin < 7;  plot_flag = 0;      end
if nargin < 6;  n = r - [1-mu;0;0]; end %assuming we are working from the secondary body
if ~iscolumn(n);    n = n';         end
if nargin < 5;  N = 100;            end
if nargin < 4;  el_max = 0;         end
if nargin < 3;  el_min = -10;       end
n = unit(n);

c = zeros(3,1);
r1 = r + [mu;0;0];
r2 = r - [1-mu;0;0];
v_mag = sqrt(r(1)^2 + r(2)^2 + 2*mu/norm(r2) + 2*(1-mu)/norm(r1) - C);
v = n*v_mag;
beta = 90-el_min;
alpha = 90-el_max;
vs = sphericalStrip(c,v,N,alpha,beta,plot_flag);

% Author: Jared Blanchard 	Date: 2020/08/18 16:24:08 	Revision: 0.1 $

end
