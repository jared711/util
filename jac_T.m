function F_T = jac_T(U, T)
%JAC_T Jacobian of stroboscopic map with respect to T
% 
% [F_T] = JAC_T(U, T)
% 
% Inputs:   U (Nxn) [] matrix of points on invariant circle
%           Τ (scalar) [NON] period of underlying periodic orbit
% 
% Outputs:  F_T () []  
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/11/10 16:28:52 	Revision: 0.1 $

[N,n] = size(U);
f = @(T) reshape(strob_map(u, T),n*N,1);
F_T = frechet(f,T);

end
