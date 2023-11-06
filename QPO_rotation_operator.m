function [R, Q, dQdrho, dRdrho, D] = QPO_rotation_operator(rho, N)
%QPO_ROTATION_OPERATOR Takes in the rotation number rho and number of points on
%invariant circle N
% 
% [R, Q, dQdrho, dRdrho, D] = QPO_ROTATION_OPERATOR(rho, N)
% 
% Inputs:   rho (scalar) [rad] rotation number
%           N (int) []  number of points along invariant circle
% 
% Outputs:  R (NxN) [] rotation operator in real domain 
%           Q (NxN) [] rotation operator in fourier domain
%           dQdrho [] partial derivative of Q w.r.t. rho
%           dRdrho [] partial derivative of R w.r.t. rho
%           D [] DFT matrix
% 
% See also: 

% Author: Jared Blanchard 	Date: 2023/04/21 16:50:29 	Revision: 0.1 $

[D, k] = QPO_fourier_operator(N); % D is the fft matrix and k is a vector of indices

Q = @(rho) diag(exp(-1i*k*rho)); % Q is the rotation operator in the fourier domain. It's a diagonal matrix made up of exponential terms
% since multiplying by e^(ikρ) rotates a point by kρ radians, we use e^(-ikρ) to rotate backwards by kρ radians.

R = @(rho) real(D\Q(rho)*D); % R is the rotation operator in the real domain. We use the similarity transform to convert it to the real domain.
% We need to use real() to make sure each component is real. Multiplying UT by R(ρ) rotates the invariant circle by ρ radians

dQdrho = @(rho) diag(-1i*k.*exp(-1i*k*rho)); % partial derivative of matrix of exponents
dRdrho = @(rho) real(D\dQdrho(rho)*D); % partial derivatives

end
