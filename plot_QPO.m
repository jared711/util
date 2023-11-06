function [h] = plot_QPO(u,T,rv0)
%PLOT_QPO Plots a QPO given invariant circle u and period T
% 
% [h] = PLOT_QPO(u, T, rv0)
% 
% Inputs:   u (Nx1 cell) [NON] invariant circle centered at origin 
%           T (scalar) [NON] Longitudinal period of QPO
%           rv0 (6x1) [NON] initial state on periodic orbit
% 
% Outputs:  h (figure handle) [] figure
% 
% See also: 

% Author: Jared Blanchard 	Date: 2023/07/20 16:55:03 	Revision: 0.1 $

global mu

if nargin < 3;  rv0 = zeros(6,1);   end
rv0 = rv0(:);

N = length(u);


for i = 1:N
    [tt,xx] = ode78e(@(t,x) CR3BP(t,x), 0, T, rv0 + u{i}(:) ,eps);
    h(i) = plot_rv(xx);
end

end
