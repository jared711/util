function idx = findapo(xx,p,num)
%FINDAPO for finding the indices of apoapses along a trajectory
% 
% FINDAPO(xx,p,num)
% 
% Inputs:
%   xx  [NX6] trajectory
%   p   [1X3] center of body that apoapsis is computed with respect to
%   num (scalar) number of apoapses to include

if nargin < 3;  num = 1;        end
if nargin < 2;  p = [0,0,0];    end

r = zeros(length(xx),1);
    for i = 1:length(xx)
        r(i) = norm(xx(i,1:3) - p);
    end
idx = find(islocalmax(r),num,'last');

% Author: Jared Blanchard 	Date: 2020/08/5 12:21:00 	Revision: 0.1 $
end