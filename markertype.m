function markertype(markertype)
if nargin < 1;  markertype = 'x';      end
markers = getmarkers;
for i = 1:length(markers)
    markers(i).Marker = markertype;
end

%Changelog
%Date               Programmer              Action
%02/25/2020         Jared T. Blanchard      Function created