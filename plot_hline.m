function [h] = plot_hline(y, varargin)
%PLOT_HLINE plots a horizontal line at position x
% 
% [h] = PLOT_HLINE(y varargin)
% 
% Inputs:   y (scalar) [] x coordinate of vertical line
%           varargin () [] normal plotting syntax
% 
% Outputs:  h (figure handle) []
% 
% See also: 

% Author: Jared Blanchard 	Date: 2023/07/21 16:21:29 	Revision: 0.1 $

xl = xlim;
plot(xl, [y,y], varargin{:})

end