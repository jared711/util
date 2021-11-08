function R = rotz(theta)
% R = rotz(theta)
% Returns a 3-by-3 matrix used to rotate a 3-by-1 vector 
% or 3-by-N matrix of vectors around the z-axis by theta radians
% 
% INPUT:    theta [rad] (scalar) rotation angle in radians
% 
% OUTPUT:   R [] (3x3) rotation matrix

R = [cos(theta), -sin(theta), 0;
     sin(theta),  cos(theta), 0;
     0         ,           0, 1];
end

% LOG: Created by Jared Blanchard 1/14/2020