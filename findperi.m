function idx = findperi(xx,p,num)
%FINDPERI for finding the indices of periapses along a trajectory
% 
% FINDPERI(xx,p,num)
% 
% Inputs:
%   xx  [NX6] trajectory
%   p   [1X3] center of body that periapsis is computed with respect to
%   num (scalar) number of periapses to include

if nargin < 3;  num = 1;        end
if nargin < 2;  p = [0,0,0];    end

r = zeros(length(xx),1);    
for i = 1:length(xx)
    r(i) = norm(xx(i,1:3) - p);
end
idx = find(islocalmin(r),num,'last');

% Author: Jared Blanchard 	Date: 2020/08/5 12:21:00 	Revision: 0.1 $
end