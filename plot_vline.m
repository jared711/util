function [h] = plot_vline(x, varargin)
%PLOT_VLINE plots a vertical line at position x
% 
% [h] = PLOT_VLINE(x, varargin)
% 
% Inputs:   x (scalar) [] x coordinate of vertical line
%           varargin () [] normal plotting syntax
% 
% Outputs:  h (figure handle) []
% 
% See also: 

% Author: Jared Blanchard 	Date: 2023/07/21 16:21:29 	Revision: 0.1 $

yl = ylim;
plot([x,x],yl,varargin{:})

end