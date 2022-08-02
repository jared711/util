function ClickOnDots
%toy initial conditions
n=1e2; R0=randn(3,n); V0=randn(3,n); tof=rand(1,n);
%plot final position
Rf=R0+V0.*tof;
figure(1e9), set(gcf,'name','pretty dots','NumberTitle','off')
handle=scatter(Rf(1,:), Rf(2,:), 9, tof, 'filled');
%set function that's called when user clicks on figure
set(handle, 'hittest', 'on', 'buttondownfcn', @click_plot);
%save data in figure
set(gcf, 'userdata', [R0;V0;tof]);

function click_plot(f,~)%plot from clicked point
x=get(f,'xdata');y=get(f,'ydata');%plotted coordinates
xy=get(get(f,'Parent'),'currentpoint');%clicked coordinate
%find point closest to click, scaled by axis limits
xyl=axis;
[~,ii]=min((x-xy(1,1)).^2/diff(xyl(1:2))^2 + (y-xy(1,2)).^2/diff(xyl(3:4))^2);
%match color
cmap=colormap; ncm=size(cmap,1); cax=caxis; cdata=get(f,'CData');
cidx=interp1(linspace(cax(1),cax(2),ncm), 1:ncm, cdata(ii), 'nearest');%index to cmap

d=get(gcf,'userdata');d=d(:,ii);%extract data from figure
%make a trajectory plot (replace with call to propagator)
t = linspace(0,d(7),1e1); R = d(1:3)+d(4:6)*t;
figure(ii),plot3(R(1,:),R(2,:),R(3,:),'color',cmap(cidx,:));axis equal
return
