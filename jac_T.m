function F_T = jac_T(u, T)
%JAC_T Jacobian of stroboscopic map with respect to T
% 
% [F_T] = JAC_T(u, T)
% 
% Inputs:   var_name (type) [units] description 
% 
% Outputs:  var_name (type) [units] description 
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/11/10 16:28:52 	Revision: 0.1 $

[n,N] = size(u);
f = @(T) reshape(strob_map(u, T),n*N,1);
F_T = frechet(f,T);

end
