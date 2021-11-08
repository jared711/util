function pot_fun
figure

mue=0.2; %---mass ratio

[X,Y] = meshgrid(-2:.01:2);
hold on
%potential function
 Z=-(X.^2+Y.^2)-(2.*(1-mue)./sqrt((X+mue).^2+Y.^2)+...
 2.*mue./sqrt((X-1+mue).^2+Y.^2))-0*mue*(1-mue);
 surf(X,Y,Z,'FaceColor',[1 0.99 1],'EdgeColor','none') %[1 0.99 1]
 camlight left; lighting phong
zlim([-3.8 -2.83])
alpha(0.5)% --- for transpancy
view([60 80])
grid on
