function [theta] = uniformAngles(N)
%UNIFORMANGLES uniformly distributed angles from 0 (inclusive) to
% 2pi (exclusive)
% 
% [theta] = UNIFORMANGLES(N)
% 
% Inputs:   N (int) [] number of angles
% 
% Outputs:  theta (1xN) [rad] angles
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/11/10 15:43:01 	Revision: 0.1 $

theta = 2*pi*(0:N-1)/N;

end
