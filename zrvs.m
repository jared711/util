function zrvs(dim,mue,C,tra)
% plot the zero velocity surface
%dim : '2d' or '3d'
%mue : mass ratio
%C : jacobi cost.
%tra : transparancy
%
%exp: zrvs('3d',0.01215,3.16,0.6)
hold on
switch dim 
 case '3d'
%---------------------------------------------------------------
d=-2:0.05:2;
[X,Y,Z] = meshgrid(d,d,d);

r1=((X + mue).^2+Y.^2+Z.^2).^(1/2);
r2=((X + mue-1).^2+Y.^2+Z.^2).^(1/2);
 V=2*[(1/2)*(X.^2 + Y.^2)+(1-mue)./r1+mue./r2];
% you may change the color in below 
h = patch(isosurface(X,Y,Z,V,C),'FaceColor','white','EdgeColor','none');
camlight; lighting phong
alpha(tra)
%view(3) 
axis off
axis equal
%-----------------------------------------------------------------
 case '2d'
%-----------------------------------------------------------------
syms X Y
f=(X.*X+Y.*Y)+2.*(1-mue)./sqrt((X+mue).^2+Y.^2)+...
 2.*mue./sqrt((X-1+mue).^2+Y.^2)+mue.*(1-mue)-C;
ezcontour(f,[-2,2],[-1.5,1.5],300);
axis equal
grid on;
%-----------------------------------------------------------------
end