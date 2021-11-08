function R = rotzd(theta)
% R = rotz(theta)
% Returns a 3-by-3 matrix used to rotate a 3-by-1 vector 
% or 3-by-N matrix of vectors around the z-axis by theta degrees
% 
% INPUT:    theta [deg] (scalar) rotation angle in degrees
% 
% OUTPUT:   R [] (3x3) rotation matrix

R = [cosd(theta), -sind(theta), 0;
     sind(theta),  cosd(theta), 0;
     0          ,  0          , 1];
end

% LOG: Created by Jared Blanchard 5/5/2020