function [l,gbar,L,G]   = rot2delv3(xx,gm)
% function [l,gbar,L,G]   = rot2delv3(xx,gm)
% 
% converts state in rotating frame to rotating Delaunay Variables.
% See equations 10.2.5 and 10.2.6 shown in Koon Lo Marsden and Ross
% Dynamical Systems Book.
% 
% inputs:
% xx        :state array [Nx4]
% gm        :gravitational parameter, central body [scalar] (unitless) {1}
% 
% outputs:
% l         :l array, mean anomaly [Nx1] (radians)
% gbar      :gbar array, rotating frame arg. of periapsis [Nx1] (radians)
% L         :L array, sqrt(gm*a) [Nx1] (radians)
% G         :G array, angular momentum [Nx1] (radians)
% 
% PROGRAMMER: Brian.Danny.Anderson@gmail.com

% LOG
% 03/16/2017, Brian D. Anderson
%   Original Code.
% 05/19/2018, Brian D. Anderson
%   added modding of gbar to fit in [-pi,pi]

% set defaults
if nargin<2;    gm  = 1;    end

% convert cartesian to polar
rr  = r2d(xx);
th  = atan2(xx(:,2),xx(:,1));
dr  =   xx(:,3).*(xx(:,1)./rr)      + xx(:,4).*(xx(:,2)./rr);
dth = - xx(:,3).*(xx(:,2)./(rr.^2)) + xx(:,4).*(xx(:,1)./(rr.^2));

% compute angular momentum (G), semimajor axis, eccentricity
G   = rr.^2.*(1 + dth);
% V2  = dr.^2 + r.^2.*(dth + 1).^2;   %should be equivalent
V2  = dr.^2 + G.^2./rr.^2;          %should be equivalent
EE  = V2/2 - gm./rr;
aa  = -gm./(2*EE);
ee  = (1 + 2*EE.*G.^2/gm^2).^.5;
% ee(find(ee>1))
% aa(find(ee>1))
% V2(find(ee>1))
% rr(find(ee>1))
% th(find(ee>1))
% find(aa<0)
% find(EE>0)
% ii = find(abs((G.^2./rr - 1)./ee)>=1)
% (G(ii).^2./rr(ii) - 1)./ee(ii)

% 2*EE    = V2 - 2./rr
% 2*EE    = dr.^2 + G.^2./rr.^2 - 2./rr
% 2*EE    = G.^2./rr.^2 - 2./rr + dr.^2

% compute L
% G       = rr.^2.*(1 + dth);
% L       = (-(G.^2./rr.^2) + (2./rr) - dr.^2).^(-0.5);   %should be equivalent, but loses sign information
% L       = (-1./(+(G.^2./rr.^2) - (2./rr) + dr.^2)).^(0.5); %should be equivalent
% L       = (-1./(2*EE)).^(0.5);                          %should be equivalent
L       = (gm*aa).^.5;                                  %should be equivalent

% compute true anomaly, and handle numerical edge cases
cosnu   = (G.^2./rr - 1)./ee; %cosine of true anomaly
edge0   = cosnu > 1  & abs(cosnu - 1) < 1e-10;
edgepi  = cosnu < -1 & abs(cosnu + 1) < 1e-10;
% edge0   = cosnu >  (1 - 1e-10); %equivalent?
% edgepi  = cosnu < -(1 - 1e-10); %equivalent?
cosnu(edge0)    = 1;
cosnu(edgepi)   = -1;
nu      = sign(dr).*acos(cosnu); %true anomaly, adjusted with quadrant check, based on radial velocity.
nu = real(nu); % added by Jared, to keep from problems that arise with tiny imaginary components

% compute argument of periapsis in rotating frame
gbar    = th - nu;
gbar    = modv2(gbar,-pi,pi);

% compute mean anomaly from true anomaly
ea      = 2*atan(sqrt((1 - ee)./(1 + ee)).*tan(nu/2)); %eccentric anomaly
l       = ea - ee.*sin(ea); %mean anomaly, also Delaunay "l"
% l       = acos((1 - rr./aa)./ee) - (rr.*dr./L); % no quadrant check here