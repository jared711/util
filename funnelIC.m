function rv = funnelIC(rv0,alpha,numpts,p,r_body,mu)
% if nargin < 5;  r_body = SEC.radius/RUNIT;  end
% if nargin < 4;  p = [1-mu,0,0];             end
% if nargin < 3;  numpts = 1000;              end
if nargin < 6;  global mu;                  end
if iscolumn(rv0);   rv0 = rv0';             end

wpos = 360;                     % circumference of projected cylinder (width of rectangle)
hpos = (1-cosd(alpha));         % height of projected cylinder (rectangle)
xpos = wpos*rand(numpts,1);     % uniform sampling along width of rectangle
ypos = hpos*rand(numpts,1);     % uniform sampling along height of rectangle
lon = xpos;                     % longitude from Saturnfacing meridian [deg]
lat = -asind(1 - hpos + ypos);  % latitude measured from equator (south pole)

% convert rv0 to lat lon
% rotate r values by lat then lon

r = rlatlon2cart([r_body*ones(size(lat)),lat,lon],p);
v_unit = rv0(4:6)/norm(rv0(4:6));

C = jacobi_constant(rv0);
r1 = sqrt((r(:,1)+mu).^2    + r(:,2).^2 + r(:,3).^2);
r2 = r_body;
% r2 = sqrt((r(:,1)-1+mu).^2  + r(:,2).^2 + r(:,3).^2); 
v = sqrt(r(:,1).^2 + r(:,2).^2 + 2*mu./r2 + 2*(1-mu)./r1 - C)*v_unit;
rv = [r,v];
end