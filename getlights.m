function lights = getlights()
% lines = getlines()
% Returns all the scatter or line objects in the current axis
lights = findobj(gcf,'Type','Light');
end

%Changelog
%Date           Programmer              Action
%02/25/2020     Jared T. Blanchard      file created
