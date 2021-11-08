function lightsoff()
lights = getlights();
for i = 1:length(lights)
    delete(lights(i));
end

%Changelog
%Date           Programmer              Action
%02/25/2020     Jared T. Blanchard      file created
