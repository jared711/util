% takes in a cylindrical coordinates converts it to the planar state
% from Travis' thesis

function [rv] = cylindricalIsomorphicMapping(x, r, theta, C)
% assume rv is a matrix made up of vectors

y_tilde = zvs_y(x,C); % maximum distance possible from x-axis
y = y_tilde - 2*y_tilde*r; % ratio of y value to maximum y value
v = vmag_CR3BP([x;y;0],C); % quadrant specific angle of velocity vector
xdot = v*cos(theta);
ydot = v*sin(theta);

rv = [x;y;xdot;ydot]; 
