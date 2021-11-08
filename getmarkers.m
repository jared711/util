function markers = getmarkers()
% lines = getlines()
% Returns all the scatter or line objects in the current axis
markers = findobj(gcf,'Type','Scatter');
end

%Changelog
%Date           Programmer              Action
%02/25/2020     Jared T. Blanchard      file created