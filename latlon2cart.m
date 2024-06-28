function [r] = latlon2cart(lat,lon,d,center)
%LATLON2CART converts latitude [rad], longitude [rad], and radial 
% distance [NON] to a cartesian position with respect to a central body
% 
% [OUTPUTARGS] = LATLON2CART(INPUTARGS)
% 
% Inputs:   lat (1xN) [rad] latitude with respect to central body 
%           lon (1xN) [rad] longitude with respect to central body 
%           d (1xN) [NON] distance from center of central body {1} 
%           center (string) [] central body for lat/lon computation {"BARY"}
% 
% Outputs:  r (3xN) [NON] position/s
%           
% See also: (deprecated) rlatlon2cart 

% Author: Jared Blanchard 	Date: 2022/11/30 15:15:08 	Revision: 0.1 $

if nargin < 3;  d = 1;  end
if nargin < 4;  center = "BARY";    end

if ~isvector(lat) || ~isvector(lon) || ~isvector(d)
    warning("lat, lon, and d should be vectors")
    keyboard
end

[m,n] = size(lat);
if m == 1
    N = n;
else
    N = m;
    lat = lat'; lon = lon'; d = d';
end


switch center
    case "BARY"
        c = [0;0;0];
    case "SEC"
        c = [1-mu;0;0];
    case "PRIM"
        c = [-mu;0;0];
end

x = d.*cos(lat).*cos(lon);
y = d.*cos(lat).*sin(lon);
z = d.*sin(lat);

r = [x;y;z] + c;

end
