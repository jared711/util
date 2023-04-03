function [D, Dinv, dDinvdtheta] = matFourier(N, n)
%MATFOURIER Truncated Fourier Transform Matrix c_vec = D*u_vec
% 
% [D, Dinv, dDinvdtheta] = MATFOURIER(N, n)
% 
% Inputs:   N (integer) [] number of points on invariant circle
%           n (integer) size of state {6}
% 
% Outputs:  var_name (type) [units] description 
% 
% See also: rotFourier

% Author: Jared Blanchard 	Date: 2022/11/10 15:38:27 	Revision: 0.1 $

if nargin < 2;  n = 6;  end

theta = uniformAngles(N);
k = fourierIndices(N);
Dsub = exp(1i*theta'*k);
Dinv = kron(Dsub, eye(n));
dDinvdtheta = kron(Dsub*diag(1i*k), eye(n));
D = inv(Dinv);

end
