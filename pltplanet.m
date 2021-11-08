function pltplanet(radius,cent,img,fig_num)
% function pltplanet(radius,cent,img)
% 
% plot sphere with planet surface texture.

% inputs:
% radius    :sphere radius [scalar] {1}
% cent      :sphere center [3x1] {[0;0;0]}
% img       :string specifying texture filename {'EarthM.png'}
% 
% outputs:
% out       :plot
% 
% LOG
% 11/21/2016
% Brian D. Anderson
%   Original Code.
% % % 05/12/2017
% % % Brian D. Anderson
% % %   Made colormap local to sphere plotted instead of whole figure.
% 
% 7/24/2020
% Jared Blanchard
% Got rid of default image
% added fig_num
% 
% Brian D. Anderson
% bdanders@usc.edu
% University of Southern California
% Los Angeles, CA

if nargin < 4;                  fig_num = get(gcf,'Number'); end
if fig_num == 0;                fig_num = get(gcf,'Number'); end 
% generate default sphere
[x,y,z] = sphere(24);

% scale sphere
x       = x * radius;
y       = y * radius;
z       = z * radius;

% offset sphere
x       = x + cent(1);
y       = y + cent(2);
z       = z + cent(3);

% plot sphere
imgRGB          = imread(img);
[imgInd,map]    = rgb2ind(imgRGB,256);
surface(x,y,z,flipud(imgInd),...
    'FaceColor','texturemap',...
    'EdgeColor','none',...
    'CDataMapping','direct','HandleVisibility','off')
colormap(gcf,map)
% ha              = surface(x,y,z,flipud(imgInd),...
%     'FaceColor','texturemap',...
%     'EdgeColor','none',...
%     'CDataMapping','direct');
% colormap(ha,map)