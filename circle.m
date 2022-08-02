function [rs] = circle(N, r, c, n)
%CIRCLE generates a circle of N points of radius r centered around c and
%facing direction n
% 
% [rs] = CIRCLE(N, r, c, n)
% 
% Inputs:   N (int) number of points in the circle {100}
%           r (scalar) radius of circle {1}
%           c (3x1) center point of circle {[0;0;0]}
%           n (3x1) normal vector to circle {[0;0;1]}
%   
% Outputs:  rs (Nx3) points along circle
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/07/28 14:11:51 	Revision: 0.1 $

if nargin < 4;  n = [0;0;1];    end
if nargin < 3;  c = [0;0;0];    end
if nargin < 2;  r = 1;          end
if nargin < 1;  N = 100;        end

if isrow(n);        n = n';                                 end
if ~iscolumn(n);    error('n should be a column vector');   end
if isrow(c);        c = c';                                 end
if ~iscolumn(c);    error('c should be a column vector');   end

theta = linspace(2*pi/N, 2*pi, N);
rs = r*[cos(theta); sin(theta); zeros(1,N)];

n_old = [0;0;1];
v = cross(n_old, n);
if norm(v) ~= 0
    % Compute the rotation matrix to properly align the new hemisphere
    % Algorithm to compute a rotation matrix between two vectors
    v = unit(v);
    skewSymmetricMat = [0 -v(3) v(2); v(3) 0 -v(1); -v(2) v(1) 0];
    A = [1 0 0; 0 1 0; 0 0 1] + skewSymmetricMat + skewSymmetricMat*skewSymmetricMat*(1 / (1 + dot(n_old,n)));
    rs = A*rs;
end


rs = rs + c;

end
