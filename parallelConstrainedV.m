function [vs] = parallelConstrainedV(rs,v,C,plot_flag)
%PARALLELCONSTRAINEDV Generates velocity vectors at each point that are
%constrained to be parallel to the input velocity and yield the same jacobi
%constant as the input
% 
% [vs] = PARALLELCONSTRAINEDV(rs,v,C)
% 
% Inputs:
%   rs          [NX3] positions of all points surrounding initial state
%   v           [3X1] velocity of initial state
%   C           (scalar) Jacobi constant of initial state
%   plot_flag   (bool) flag for plotting [0]
% 
% Outputs
%   vs      [NX3] velocities of all points surrounding initial state,
%           parallel to v with state constrained to C
% 
% Provide sample usage code here
% 
% See also: List related files here

if nargin < 4;  plot_flag = 0;  end

global mu

N = length(rs);
v_unit = v/norm(v);

r1 = rs + [mu,0,0];
r2 = rs - [1-mu,0,0];

vs = zeros(N,3);
for i = 1:N
    v_mag = sqrt(rs(i,1)^2 + rs(i,2)^2 + 2*mu/norm(r2(i,:)) + 2*(1-mu)/norm(r1(i,:)) - C);
    vs(i,:) = v_unit*v_mag;
end

if plot_flag
    quiver3(rs(:,1),rs(:,2),rs(:,3),vs(:,1),vs(:,2),vs(:,3))
end

% Author: Jared Blanchard 	Date: 2020/07/23 20:20:32 	Revision: 0.1 $



end
