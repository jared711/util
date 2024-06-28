function [F_x] = jac_x(U, T, rv0)
%JAC_X Jacobian of stroboscopic map with respect to invariant circle
% 
% [F_x] = JAC_X(u, T)
% 
% Inputs:   U (Nxn) [NON] states on invariant circle
%           T (scalar) [NON] period of stroboscopic map
%           rv0 (nx1) [NON] base point of invariant circle
% 
% Outputs:  F_x (nNxnN) [] Jacobian 
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/11/10 16:09:58 	Revision: 0.1 $

if nargin < 3
    warning("Are you using u based at rv0 or at the barycenter?")
    rv0 = zeros(6,1);
end

[N,n] = size(U);
F_x = zeros(n*N);
for i = 1:N
    idx = (i-1)*n + 1:i*n;
    F_x(idx, idx) = monodromy(rv0 + U(i,:),T);
end

end
