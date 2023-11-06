function [h] = plot_traj(xx, varargin)
%PLOT_TRAJ Plots a trajectory
% 
% [h] = PLOT_TRAJ(xx)
% 
% Inputs:   xx (nxm) [NON] state vectors for plotting
%           varargin () [] normal plotting syntax
% 
% Outputs:  h (figure handle) []
% 
% See also: 

% Author: Jared Blanchard 	Date: 2023/07/21 17:36:32 	Revision: 0.1 $

[n,m] = size(xx);
if n ~= 7 && n~= 6 && n~= 3 && n ~= 42
    if m == 7 || m == 6 || m == 3 || m == 42 
        xx = xx';
        n = m;
    else
        error("xx must be 7XN, 6xN, 3xN, or 42xN")
    end     
end
if n == 42
    xx = xx(37:42,:);
end


h = plot3(xx(1,:),xx(2,:),xx(3,:),varargin{:});
plot_trajLabel

end
