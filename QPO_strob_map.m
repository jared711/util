function [F, PHI_tilde] = QPO_strob_map(rv0, U, T, mu)
%QPO_STROB_MAP computes the stroboscopic map of points u after integrating for
%period T
% 
% [F] = QPO_STROB_MAP(rv0, U, T, mu)
% 
% Inputs:   rv0 (nx1) [NON] base point of invariant circle
%           U (Nxn) [NON] points on invariant circle
%           T (scalar) [NON] period of integration
%           mu (scalar) [NON] mass parameter
% 
% Outputs:  F (nxN) [NON] stroboscopic map 
%           PHI_tilde (nNxnN) [NON] Block diagonal matrix of STMs
% 
% See also: QPO_differential_corrector

% Author: Jared Blanchard 	Date: 2022/11/10 15:47:18 	Revision: 0.1 $
% Author: Jared Blanchard 	Date: 2023/04/21 17:46:08 	Revision: 0.2 $

if nargin < 4;  global mu;  end

[N,n] = size(U);
if n > N % make sure U0 is Nxn
    warning("n is larger than N. Taking transpose of U0 to make it an array of row vectors")
    U = U';
    [N,n] = size(U);
end

F = zeros(N,n);
PHI_0 = eye(n);
PHI_tilde = zeros(n*N,n*N);
for i = 1:N
    y0 = [reshape(PHI_0, n^2, 1); rv0 + U(i,:)'];
    [~,xx] = ode78e(@(t,x) CR3BP_STM(t,x,mu), 0, T, y0, eps);
    F(i,:) = xx(end,37:42) - rv0'; % final state of integration
    
    idx = (i-1)*n + 1:i*n;
    PHI_tilde(idx, idx) = reshape(xx(end,1:36), n, n); % this is the final STM
end

end
