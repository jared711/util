function x0 = linpol2(x,y,yval)
% x0 = linpol2(x,y,yval)
% 
% linear interpolation between 2 points. Finds x0 such that y(x0) = yval
% 
% inputs [dimensions] (defaults):
% t     :array of 2 x-points [2xN]
% y     :array of 2 y-points [2x1]
% yval  :desired value of y(x0) [scalar]
% 
% outputs [dimensions]:
% x0    :such that y(x0) = yval [1xN]
% 
% LOG
% 12/06/2015    
% Brian D. Anderson   
%   Original Code.
% 
% Brian D. Anderson
% bdanders@usc.edu
% University of Southern California
% Los Angeles, CA


%t @ yval intersect
x0  = x(1,:) + (x(2,:) - x(1,:))*(yval - y(1))/(y(2) - y(1));