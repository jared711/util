function cart = rlatlon2cart(X,p)
%cart = rlatlon2cart(X, p)
%Calculates Cartesian coordinates from radius, latitude, and longitude
%Inputs:
%   X   =   [Nx3] [radius, latitude, longitude] in degrees

if nargin < 2;  p = [0,0,0];    end

r = X(:,1);
lat = X(:,2);
lon = X(:,3);

x = -r.*cosd(lat).*cosd(lon);
y = -r.*cosd(lat).*sind(lon);
z = r.*sind(lat);

cart = [x,y,z] + p;

%Changelog
%Date               Programmer              Action
%November 13, 2019  Jared T. Blanchard      Code written