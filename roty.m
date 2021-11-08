function R = roty(theta)
% R = rotz(theta)
% Returns a 3-by-3 matrix used to rotate a 3-by-1 vector 
% or 3-by-N matrix of vectors around the y-axis by theta radians
% 
% INPUT: theta [scalar] rotation angle in radians
% OUTPUT: R [3x3] rotation matrix

R = [ cos(theta), 0, sin(theta);
      0          , 1, 0;
     -sin(theta), 0, cos(theta)];
end

% LOG: Created by Jared Blanchard 1/14/2020