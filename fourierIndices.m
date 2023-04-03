function [k] = fourierIndices(N)
%FOURIERINDICES indices to compute Discrete Fourier Transform matrix
% 
% [k] = FOURIERINDICES(N)
% 
% Inputs:   N (integer) number of points on invariant circle
% 
% Outputs:  k (1xN) [] fourier indices 
% 
% See also: rotFourier

% Author: Jared Blanchard 	Date: 2022/11/10 15:33:21 	Revision: 0.1 $

if mod(N,2)
    k = -(N-1)/2:(N-1)/2; % k indices centered at zero
else
    error("N should be odd")
end

end
