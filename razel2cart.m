function vec = razel2cart(az,el,lon,lat,rmag,vmag)
% function vec = azel2cart(rr,az,el,lon,lat,mag)
% 
% compute cartesian vector from azimuth, elevation, latitude and longitude
% 
% intputs:
% rr        :radius [Nx1]
% az        :azimuth, radians [Nx1]
% el        :elevation, radians [Nx1]
% lon       :longitude, radians [Nx1]
% lat       :latitude, radians [Nx1]
% rmag      :radius vector magnitude [Nx1] {1}
% vmag      :velocity vector magnitude [Nx1] {1}
% 
% outputs:
% vec       :cartesian state vector [Nx6]
% Programmer: Brian.Danny.Anderson@gmail.com

% LOG
% 09/07/2018, Brian D. Anderson
%   Original Code.


% set defaults
if nargin < 6;  vmag    = 1;    end
if nargin < 5;  rmag    = 1;    end

% initialize output array
npts    = max([length(az),length(el),length(lon),length(lat),length(rmag),length(vmag)]);
vec     = zeros(npts,6);

% precompute trig
caz     = cos(az);
saz     = sin(az);
cel     = cos(el);
sel     = sin(el);
clat    = cos(lat);
slat    = sin(lat);
clon    = cos(lon);
slon    = sin(lon);

% compute vector components
c1 			= caz.*cel;
c2 			= saz.*cel;
c3 			= clat.*sel - slat.*c1;
vec(:,1)    = rmag.*clon.*clat;
vec(:,2)    = rmag.*slon.*clat;
vec(:,3)    = rmag.*slat;
vec(:,4)    = vmag.*(clon.*c3 - slon.*c2);
vec(:,5)    = vmag.*(slon.*c3 + clon.*c2);
vec(:,6)    = vmag.*(slat.*sel + clat.*c1);
%{
vec(:,1)    = vmag.*(clon.*(clat.*sel - slat.*caz.*cel) - slon.*saz.*cel);
vec(:,2)    = vmag.*(slon.*(clat.*sel - slat.*caz.*cel) + clon.*saz.*cel);
vec(:,3)    = vmag.*(slat.*sel + clat.*caz.*cel);
%}
