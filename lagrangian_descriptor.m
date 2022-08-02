function [LDs] = lagrangian_descriptor(rvs, tau, method)
%LAGRANGIAN_DESCRIPTOR computes Lagrangian descriptors for a set of initial
%conditions given a tau and a method
% 
% [LDs] = LAGRANGIAN_DESCRIPTOR(rvs, tau)
% 
% Inputs:   rvs (Nx6) [NON] initial conditions
%           tau (scalar) [NON] time to be integrated forward and back
%           method (string) result of integration {'arclenth'}
% 
% Outputs:  LDs (1xN) Lagrangian descriptors for each initial condition
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/07/05 09:56:16 	Revision: 0.1 $

if nargin < 3;  method = 'arclength';   end % there's currently only one method implemented, so this is a useless variable
if nargin < 2;  tau = 1e-1; end % 1e-1 is about 1.35 hour

[m,n] = size(rvs);
if m == 6;  rvs = rvs';
elseif n ~= 6;  error('rvs should be Nx6'); end

N = length(rvs);
LDs = zeros(1,N);
for i = 1:N
    sprintf("i = %i/%i", i, N)
    [~,xx] = ode78e(@(t,x) CR3BP_LD(t,x), 0,  tau, [rvs(i,:), 0], 1e-12);
    LDs(i) = LDs(i) + xx(end,7);
    [~,xx] = ode78e(@(t,x) CR3BP_LD(t,x), 0, -tau, [rvs(i,:), 0], 1e-12);
    LDs(i) = LDs(i) - xx(end,7);
end
    

end
