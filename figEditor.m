rmpath('~/jared711@stanford.edu/STANFORD/Research/OrbitalResearch/misc/util/')
addpath('~/jared711@stanford.edu/STANFORD/Research/OrbitalResearch/misc/util/')

seteuropaglobal
lines = getlines;
%%
 lighting gouraud
%%
for i = 1:length(lines)
if lines(i).Marker == 'v';
lines(i).MarkerEdgeColor = 'm'
end
end
%%
for i = 1:length(lines)
if lines(i).Marker == 'v';
lines(i).SizeData = 400;
lines(i).LineWidth = 5;
end
end
%%
new_color = [0,.65,1];
for i = 1:length(lines)
    if lines(i).Color == prev_color            
        lines(i).Color = new_color;
    end
end
prev_color = new_color;
%%
for i = 1:length(lines)
    if lines(i).Color == [0,0,1]           
        lines(i).MarkerSize = 30;
    end
end
%%
for i = 1:length(lines)
    lines(i).LineWidth = 4;
end
%%
for i = 1:length(lines)
lines(i).SizeData = 100;
end
%%
for i = 1:length(lines)
lines(i).MarkerSize = 15;
end
%%
for i = 1:length(lines)
lines(i).LineWidth = 3;
end
%% Zoom in on Europa
axis([0.975,1.03,-0.015,0.02,-0.012,0.012])
%% Full Orbit
axis([-1.3,1.2,-0.12,1.3,-0.12,0.12])
%% XZ plane
view([0,-1,0])
axis([0.99,1.03,-0.015,0.02,-0.012,0.012])
