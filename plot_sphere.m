function plot_sphere(radius,cent,fig,col,npts,handleVis,myalpha)
% function plot_sphere(radius,cent,fig,col,npts,handleVis,myalpha)
if nargin < 7;  myalpha = 1;        end
if nargin < 6   handleVis = 'off';   end
if nargin < 5   npts    = 500;      end
if nargin < 4   col     = 'b';      end
if nargin < 3   fig     = 1;        end
if nargin < 2   cent    = [0;0;0];  end
if nargin < 1   radius  = 1;        end

% generate default sphere
[x,y,z] = sphere(npts);

% scale sphere
x       = x * radius;
y       = y * radius;
z       = z * radius;

% offset sphere
x       = x + cent(1);
y       = y + cent(2);
z       = z + cent(3);

% plot sphere
figure(fig)
mysurf = surf(x,y,z,'FaceColor',col,'EdgeColor','none','HandleVisibility',handleVis);
set(mysurf, 'FaceAlpha', myalpha);

%Changelog
%Date           Programmer              Action
%08/22/2019     Jared T. Blanchard      File created from pltsphere
%04/09/2021     Jared T. Blanchard      Added alpha