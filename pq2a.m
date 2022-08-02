function [a] = pq2a(p,q)
%PQ2A compute semimajor axis from integers p and q
% 
% [a] = PQ2A(p,q)
% 
% Inputs: 
% 
% Outputs: 
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/02/08 09:58:24 	Revision: 0.1 $

L = pq2L(p,q);
a = L^2;

end
