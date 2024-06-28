function [lat,lon,d] = cart2latlon(rv, center)
%CART2LATLON computes the latitude [rad], longitude [rad], and radial 
% distance [NON] of a state with respect to a central body.
% 
% [lat,lon,d] = CART2LATLON(rv, center)
% 
% Inputs:   rv (6xN) [NON] state/s
%           center (string) [] central body for lat/lon computation {"BARY"}
% 
% Outputs:  lat (1xN) [rad] latitude with respect to central body 
%           lon (1xN) [rad] longitude with respect to central body 
%           d (1xN) [NON] distance from center of central body 
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/11/30 14:55:41 	Revision: 0.1 $
global mu

if nargin < 2;  center = "BARY";    end

[m,n] = size(rv);
if m == 6
    N = n; % N is number of states
elseif n == 6
    rv = rv';
    N = m; % N is number of states
elseif m == 3 % instead of position and velocity (rv) I can input just position (r)
    N = n;
elseif n == 3
    rv = rv';
    N = m;
end

switch center
    case "BARY"
        c = [0;0;0];
    case "SEC"
        c = [1-mu;0;0];
    case "PRIM"
        c = [-mu;0;0];
end

r = rv(1:3,:) - c;
d = vecnorm(r); % |r|
lat = asin(r(3,:)./d); % asin(z/|r|)
lon = atan2(r(2,:),r(1,:)); % atan(y,x)

end
