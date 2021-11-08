function [p,q] = L2pq(L,tol)
% function [p,q] = L2pq(L,tol)
% 
% Approximate resonance ratio p,q from Delaunay L.
% 
% inputs:
% L     :Delaunay L [Nx1]
% tol   :tolerance for ratio approximation [scalar] {1e-2}
%
% outputs:
% p     :relative mean motion of particle [Nx1]
% q     :relative mean motion of primaries [Nx1]
% 
% Programmer: Brian D. Anderson

% LOG
% 06/21/2018, Brian D. Anderson
%   Original Code.


% set defaults
if nargin<2;    tol     = 1e-2;     end

% approximate the ratio
[q,p]   = rat(L.^3,tol);