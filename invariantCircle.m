function [u, rho, eig_idx] = invariantCircle(rv0, T0, N, alpha)
%INVARIANTCIRCLE computes invariant circle approximation from center
%manifold of periodic orbit
% 
% [u, rho] = INVARIANTCIRCLE(rv0, T0, N, alpha)
% 
% Inputs:   rv0 (6x1) [NON] initial state of periodic orbit 
%           T0 (scalar) [NON] period of periodic orbit
%           N (int) [] number of points on invariant circle {99}
%           alpha (scalar) [] offset from periodic orbit {1e-5}
% 
% Outputs:  u (6xN) [NON] Invariant Circle 
%           rho (scalar) [rad] rotation number
%           eig_idx (int) [] index of chosen eigenvalue
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/11/10 16:46:58 	Revision: 0.1 $
if nargin < 4;  alpha = 1e-5;   end
if nargin < 3;  N = 99;         end

PHI_T = monodromy(rv0,T0);
[Veig,Deig] = eigenshuffle(PHI_T);

centers = find(abs(imag(Deig)) > 1e-3);
switch length(centers)
    case 0
        warning("No complex eigenvalues")
        keyboard
    case 2
        eig_idx = centers(1);
    case 4
        warning("Two center pairs")
        eig_idx = centers(1);
        keyboard
    otherwise
        warning("Unexpected eigenvalues")
        keyboard
end        

rho = real(-1i*log(Deig(eig_idx)));
% also, could use
% rho  = atan2(imag(Deig(eig_idx)), real(Deig(eig_idx)));

theta = uniformAngles(N);
n = length(Veig(:,eig_idx));
u = zeros(n,N);
for i = 1:N
%     u(:,i) = rv0 + alpha*(cos(theta(i))*real(Veig(:,eig_idx)) - sin(theta(i))*imag(Veig(:,eig_idx)));
    u(:,i) = alpha*(cos(theta(i))*real(Veig(:,eig_idx)) - sin(theta(i))*imag(Veig(:,eig_idx)));
end

end
