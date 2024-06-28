function [outputArgs] = eig_sort(A)
%EIG_SORT Computes eigenvalue decomposition of matrix and sorts the
%eigenvalues and eigenvectors
% 
% [OUTPUTARGS] = EIG_SORT(INPUTARGS)
% 
% Inputs:   var_name (type) [units] description 
% 
% Outputs:  var_name (type) [units] description 
% 
% See also: 

% Author: Jared Blanchard 	Date: 2023/08/07 16:01:04 	Revision: 0.1 $

[V,D] = eig(A);
lambda = diag(D);

idx_real = find(imag(lambda) == 0);
for i = idx_real
    if abs(abs(lamda(i)) - 1) < 1e-3 % no imaginary part and right next to 1
        eigs.lambda_I1 = 
        eigs.identity.v1 = V(:,i)


eigs.stable
eigs.unstable
eigs.identity

end
