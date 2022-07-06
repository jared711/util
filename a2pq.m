function [p,q] = a2pq(a, tol)
%A2PQ compute integers p and q from semimajor axis a
% 
% [p,q] = A2PQ(a)
% 
% Inputs: 
% 
% Outputs: 
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/02/08 10:00:07 	Revision: 0.1 $

if nargin < 2;  tol = 1e-2; end
L = sqrt(a);
[p,q] = L2pq(L, tol);

end
