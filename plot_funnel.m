function [h] = plot_funnel(funnel, varargin)
%PLOT_FUNNEL plot a funnel object
% 
% [h] = PLOT_FUNNEL(funnel)
% 
% Inputs:   funnel (cell {Nt} (Ntx7)) [] funnel object holding all the trajectories with time 
% 
% Outputs:  h (handle) [] plot of funnel 
% 
% See also: 

% Author: Jared Blanchard 	Date: 2023/10/16 09:33:05 	Revision: 0.1 $

p = inputParser;
p.KeepUnmatched=true; % allows unknown parameters to pass through
addOptional(p,'rings', false, @islogical)
addOptional(p,'canonical', false, @islogical)
addOptional(p,'dt', 10, @isnumeric)
parse(p,varargin{:})
rings = p.Results.rings;
canonical = p.Results.canonical;
dt = p.Results.dt;

varargin(find(strcmp(varargin,'rings')):find(strcmp(varargin,'rings'))+1) = [];
varargin(find(strcmp(varargin,'canonical')):find(strcmp(varargin,'canonical'))+1) = [];
varargin(find(strcmp(varargin,'dt')):find(strcmp(varargin,'dt'))+1) = []; % deletes this from varargin so it doesn't bring up an error when passing through to plot_traj

N = length(funnel);
Nt = length(funnel{1});

if rings
    for j = 1:dt:Nt
        xx = zeros(N,6);
        for i = 1:N
            xx(i,:) = funnel{i}(j,1:6);
        end
        h=plot_traj(xx,varargin{:});
        hold on
    end
else
    for i = 1:N
        xx = funnel{i};
        if canonical;   xx = canonicalCoords(xx);   end
        h=plot_traj(xx,varargin{:});
        hold on
    end
end

plot_trajLabel

end
