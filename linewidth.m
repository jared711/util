function linewidth(linewidth)
if nargin < 1;  linewidth = 2;  end
lines = getlines;
for i = 1:length(lines)
    lines(i).LineWidth = linewidth;
end
end

%Changelog
%Date               Programmer              Action
%02/25/2020         Jared T. Blanchard      Function created