function [D, k, theta] = QPO_fourier_operator(N)
%QPO_FOURIER_OPERATOR Summary of this function goes here
% 
% [D, k, theta] = QPO_FOURIER_OPERATOR(N)
% 
% Inputs:   N (int) [] number of points on invariant circle 
% 
% Outputs:  D (NxN) [] DFT matrix 
%           k (Nx1) [] indices used in DFT matrix
%           theta (Nx1) [rad] angles of points on invariant circle
% 
% See also: 

% Author: Jared Blanchard 	Date: 2023/04/21 17:08:57 	Revision: 0.1 $

if mod(N,2) == 0;   error("N should be odd");   end

theta = 2*pi*(0:N-1)/N; % angles of points on the invariant circle
theta = theta'; %make it a column vector

k = -(N-1)/2:(N-1)/2; % k indices centered at zero
k = k'; % make it a column vector

D = 1/N*exp(-1i*k*theta'); % DFT matrix

end
