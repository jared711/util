function ha = plt2dw(xc,col,LW,LS,M,MS)
% function ha = plt2dw(xc,col,LW,LS,M,MS)
% 
% plot cell array of trajectories' position in 2D. Color can be array with
% one color for each trajectory.
% USE:
% plt2dw(xc,col,LW,LS,M,MS) (no object output)
% hl = plt2dw(xc,col,LW,LS,M,MS); (with object output)
% 
% inputs:
% xc        :cell array of trajectories{1xN}[Mx4]
% col       :line color, RGB [1x3] or [Nx3] {[0 0 0], black}
% LW        :line width [scalar] {0.5}
% LS        :line style {'-'}
% M         :marker style {'none'}
% MS        :marker size [scalar] {5}
% 
% outputs:
% ha        :line object handle (optional output)
% 
% PROGRAMMER: Brian.Danny.Anderson@gmail.com

% LOG
% 12/16/2017, Brian D. Anderson
%   Original Code.
% 05/31/2018, Brian D. Anderson
%   Removed extraction of 4 columns from cell, to all columns. This enables
%   using this to plot things other than 4d states.


% set defaults
if nargin < 6;  MS      = 5;        end
if nargin < 5;  M       = 'none';   end
if nargin < 4;  LS      = '-';      end
if nargin < 3;  LW      = 0.5;      end
if nargin < 2;  col     = [0 0 0];  end

% determine number of trajectories
n       = length(xc);
ncol    = size(col,1);

% initialize output handle array
if nargout ~= 0
    ha  = gobjects(n,1);
end

% plot all trajectories
for kk = 1:n
    % extract current trajectory
    xk          = xc{kk};
    
    % set current color
    if ncol==n
        colk    = col(kk,:);
    else
        colk    = col(1,:);
    end
    
    % plot current trajectory
    if nargout ~= 0
        ha(kk) = plot(xk(:,1),xk(:,2),'color',colk,'LineStyle',LS,...
            'LineWidth',LW,'Marker',M,'MarkerSize',MS);
    else
        plot(xk(:,1),xk(:,2),'color',colk,'LineStyle',LS,...
            'LineWidth',LW,'Marker',M,'MarkerSize',MS);
    end
end