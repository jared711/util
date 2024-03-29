function [h] = plot_ellipse(Mu,Sigma,p,a)
%PLOT_ELLIPSE Plots a 2D ellipse or 3D ellipsoid centered at Mu and defined
%by Sigma where points x on the boundary of the ellipse are defined by
%x'*inv(Sigma)*x < sqrt(-2*log(1-p))
% 
% [OUTPUTARGS] = PLOT_ELLIPSE(mu,Sigma,P)
% 
% Inputs: 
%           Mu (2x1) or (3x1) mean vector
%           Sigma (2x2) or (3x3) covariance matrix
%           p = (scalar) probability of ellipsoid
%           a = (integer) color index
% 
% Outputs: 
%           h (figure handle) output figure
% 
% See also: 

% Author: Jared Blanchard 	Date: 2021/04/24 15:49:56 	Revision: 0.1 $
if nargin < 4;  a = 1;      end
if nargin < 3;  p = 0.3935; end
if isrow(Mu);   Mu = Mu';   end

r = sqrt(-2*log(1-p));

if length(Mu) == 2
    theta = linspace(0,2*pi);
    cxy = sqrtm(Sigma)*[r*cos(theta); r*sin(theta)] + Mu;
    cx = cxy(1,:);
    cy = cxy(2,:);
    h = plot(cx,cy);
elseif length(Mu) == 3
    n = 20;
    theta = pi*(-n:2:n)/n;
    phi = (pi/2)*(-n:2:n)'/n;
    X = r*cos(phi)*cos(theta);
    Y = r*cos(phi)*sin(theta);
    Z = r*sin(phi)*ones(size(theta));
    xyz = [vec(X), vec(Y), vec(Z)];
    cxyz = real(sqrtm(Sigma))*xyz' + Mu;
    cx = reshape(cxyz(1,:),size(X));
    cy = reshape(cxyz(2,:),size(Y));
    cz = reshape(cxyz(3,:),size(Z));
%     [X,Y,Z] = meshgrid(cx,cy,cz);
%     plot3(cx,cy,cz,'.')
    h = surf(cx,cy,cz,a*ones(size(X)),'EdgeColor','none','HandleVisibility','off');%,'FaceColor','c');
else
    warning("Mu should be 2x1 or 3x1")
end

end
