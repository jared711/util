function [Q] = rotFourier(rho, N, n)
%ROTFOURIER Rotation Operator on Fourier coefficients for use in diffCorQPO
% 
% [Q] = ROTFOURIER(rho, N, n)
% 
% Inputs:   rho (scalar) [rad] rotation number 
%           N (int) [] number of points on invariant circle
%           n (int) [] size of state
% 
% Outputs:  var_name (type) [units] description 
% 
% See also: diffCorrQPO

% Author: Jared Blanchard 	Date: 2022/11/10 15:27:14 	Revision: 0.1 $

k = fourierIndices(N);
Q_vec = kron(exp(1i*k*rho),ones(1,n));
Q = diag(Q_vec);

end
