function [] = plot_resLines(num_res, var, ax)
%PLOT_RESLINES Summary of this function goes here
% 
% [] = PLOT_RESLINES(num_res, var, ax)
% 
% Inputs:   num_res [] (integer) number of resonances to show {7}
%           var [] (string) variable in use: semimajor axis 'a' or Delaunay variable 'L' {'a'}
%           ax [] (string) axis on which var is plotted {'y'}
% 
% Outputs: 
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/04/18 17:41:03 	Revision: 0.1 $

if nargin < 3;  ax = 'y';   end
if nargin < 2;  var = 'a';  end
if nargin < 1; num_res = 7; end

ylim = get(gca, 'ylim');
xlim = get(gca, 'xlim');

if ax == 'y'
    vals = linspace(ylim(1),ylim(2),num_res);
elseif ax == 'x'
    vals = linspace(xlim(1),xlim(2),num_res);
else
    warning('ax should be "x" or "y"')
end

for k = 1:num_res
    switch string(var)
        case "a"
            [p,q] = a2pq(vals(k));
            line = pq2a(p,q);
        case "L"
            [p,q] = L2pq(vals(k));
            line = pq2L(p,q);
    end
    
    if ax == 'y'
        plot([xlim(1), xlim(2)],[line,line],'k--','LineWidth',0.5)
        text(xlim(2),line,sprintf("%i:%i",p,q),'HorizontalAlignment', 'left', ...
        'VerticalAlignment', 'middle')
    elseif ax == 'x'
        plot([line,line],[ylim(1), ylim(2)],'k--','LineWidth',0.5)
        text(line,ylim(2),sprintf("%i:%i",p,q),'HorizontalAlignment', 'left', ...
        'VerticalAlignment', 'bottom', 'Rotation', 60)
    else
        warning('ax should be "x" or "y"')
    end
end


end
