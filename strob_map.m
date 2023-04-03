function [F] = strob_map(u, T, rv0)
%STROB_MAP computes the stroboscopic map of points u after integrating for
%period T
% 
% [OUTPUTARGS] = STROB_MAP(INPUTARGS)
% 
% Inputs:   u (nxN) [NON] points on invariant circle
%           T (scalar) [NON] period of integration
%           rv0 (nx1) [NON] base point of invariant circle
% 
% Outputs:  F (nxN) [N] stroboscopic map 
% 
% See also: diffCorrQPO

% Author: Jared Blanchard 	Date: 2022/11/10 15:47:18 	Revision: 0.1 $

if nargin < 3
    warning("Are you using u based at rv0 or at the barycenter?")
    rv0 = zeros(6,1);
end

F = zeros(size(u));
for i = 1:length(u)
    [~,xx] = ode78e(@(t,x) CR3BP(t,x), 0, T, rv0 + u(:,i) ,eps);
    F(:,i) = xx(end,:)' - rv0;
end

end
