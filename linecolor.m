function linecolor(color,prev_color)
%Changes line colors of prev_color to color
if nargin < 2;  prev_color = 0; end
if nargin < 1;  color = 2;      end
lines = getlines;
for i = 1:length(lines)
    if prev_color == 0
        lines(i).Color = color;
    elseif lines(i).Color == prev_color
        lines(i).Color = color;
    end
end
end

%Changelog
%Date               Programmer              Action
%02/25/2020         Jared T. Blanchard      Function created