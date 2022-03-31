function h = plot_rv(rv,col,proj,linewidth,handlevis)
% h=plot_rv(rv,col,proj,linewidth,handlevis)
% Plots a point or trajectory
% Inputs:
%     rv = [6xN] state vectors [rv1, rv2] where rv = [rx;ry;rz;vx;vy;vz]
%     col = (char) color of line ['k']
%     proj = (scalar) projection type [4]
%     linewidth = (scalar) width of plotted line [0.5]
%     handlevis = (string) handle visibility ['on']
%       1  xy
%       2  xz
%       3  yz
%       4  xyz
%       5  all

if nargin < 5;  handlevis='on'; end
if nargin < 4;  linewidth=0.5;  end
if nargin < 3;  proj=4;         end
if nargin < 2;  col='k';        end

[n,m] = size(rv);
if n ~= 7 && n~= 6 && n~= 3 && n ~= 42
    if m == 7 || m == 6 || m == 3 || m == 42 
        rv = rv';
        n = m;
    else
        error("rv must be 7XN, 6xN, 3xN, or 42xN")
    end     
end
if n == 42
    rv = rv(37:42,:);
end


if proj <= 1
   plot(rv(1,:),rv(2,:),col,'LineWidth',linewidth,'HandleVisibility',handlevis); hold on
   xlabel('X [NON]');ylabel('Y [NON]')
elseif proj==2
   plot(rv(1,:),rv(3,:),col,'LineWidth',linewidth,'HandleVisibility',handlevis); hold on
   xlabel('X [NON]');ylabel('Z [NON]')
elseif proj==3
   plot(rv(2,:),rv(3,:),col,'LineWidth',linewidth,'HandleVisibility',handlevis); hold on
   xlabel('Y [NON]');ylabel('Z [NON]')
elseif proj==4
   plot3(rv(1,:),rv(2,:),rv(3,:),col,'LineWidth',linewidth,'HandleVisibility',handlevis); hold on
   xlabel('X [NON]');ylabel('Y [NON]');zlabel('Z [NON]')
   view(2)
elseif proj==5
   subplot(2,2,1), plot(rv(1,:),rv(2,:),col,'LineWidth',linewidth,'HandleVisibility',handlevis);grid;axis('equal');
   xlabel('X [NON]');ylabel('Y [NON]');
   hold on;
   subplot(2,2,2), plot(rv(1,:),rv(3,:),col,'LineWidth',linewidth,'HandleVisibility',handlevis);grid;axis('equal');
   xlabel('X [NON]');ylabel('Z [NON]');
   hold on;
   subplot(2,2,3), plot(rv(2,:),rv(3,:),col,'LineWidth',linewidth,'HandleVisibility',handlevis);grid;axis('equal');
   xlabel('Y [NON]');ylabel('Z [NON]');
   hold on;
   subplot(2,2,4), plot3(rv(1,:),rv(2,:),rv(3,:),col,'LineWidth',linewidth,'HandleVisibility',handlevis);
   xlabel('X [NON]');ylabel('Y [NON]');zlabel('Z [NON]');axis('equal');
   hold on;
end

grid on
axis equal

if nargout > 0; h = gcf;    end

%Changelog
%Date           Programmer              Action
%08/14/2019     Jared T. Blanchard      file created from plt.m
%08/20/2019     Jared T. Blanchard      added 'LineWidth', linewidth capability
%02/12/2020     Jared T. Blanchard      added size recognition for STM