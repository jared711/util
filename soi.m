function [r_SOI] = soi(a,m,M)
%SOI Computes sphere of influence of a small body relative to a larger body
% 
% [r_SOI] = SOI(a,m,M)
% 
% Inputs:   a (scalar) [km] semimajor axis
%           m (scalar) [kg] mass of smaller body
%           M (scalar) [kg] mass of larger body
% 
% Outputs:  r_SOI (scalar) [km] radius of sphere of influence 
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/12/17 09:45:57 	Revision: 0.1 $

r_SOI = a*(m/M)^(2/5);

end
