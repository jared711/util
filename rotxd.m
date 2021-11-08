function R = rotxd(theta)
% R = rotz(theta)
% Returns a 3-by-3 matrix used to rotate a 3-by-1 vector 
% or 3-by-N matrix of vectors around the x-axis by theta degrees
% 
% INPUT: theta [scalar] rotation angle in degrees
% OUTPUT: R [3x3] rotation matrix

R = [1, 0,            0;
     0, cosd(theta), -sind(theta);
     0, sind(theta),  cosd(theta)];
end

% LOG: Created by Jared Blanchard 5/5/2020