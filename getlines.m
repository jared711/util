function lines = getlines()
% lines = getlines()
% Returns all the scatter or line objects in the current axis
lines = findobj(gcf,'Type','Line');
end

%Changelog
%Date           Programmer              Action
%02/11/2020     Jared T. Blanchard      file created
