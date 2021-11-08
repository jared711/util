function markersize(markersize)
if nargin < 1;  markersize = 2;      end
markers = getmarkers;
for i = 1:length(markers)
    markers(i).SizeData = markersize;
    markers(i).LineWidth = markersize/40;
end

%Changelog
%Date               Programmer              Action
%02/25/2020         Jared T. Blanchard      Function created