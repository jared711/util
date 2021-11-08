function [h] = plot_ellipse(mu,Sigma,P,col_idx)
%PLOT_ELLIPSE Summary of this function goes here
% 
% [OUTPUTARGS] = PLOT_ELLIPSE(mu,Sigma,P)
% 
% Inputs: 
%           mu (3x1) [] mean vector
%           Sigma (3x3) [] covariance matrix
%           P (scalar) {0.3935}
%           col_idx (integer) determines the color of the ellipsoid
% 
% Outputs: 
%           h (handle) surface plot
% 
% See also: 

% Author: Jared Blanchard 	Date: 2021/04/24 15:49:56 	Revision: 0.1 $
if nargin < 3;  P = 0.3935; end
if isrow(mu);   mu = mu';   end

r = sqrt(-2*log(1-P));

if length(mu) == 2
    theta = linspace(0,2*pi);
    cxy = sqrtm(Sigma)*[r*cos(theta); r*sin(theta)] + mu;
    cx = cxy(1,:);
    cy = cxy(2,:);
    h = plot(cx,cy);
elseif length(mu) == 3
    n = 20;
    theta = pi*(-n:2:n)/n;
    phi = (pi/2)*(-n:2:n)'/n;
    X = r*cos(phi)*cos(theta);
    Y = r*cos(phi)*sin(theta);
    Z = r*sin(phi)*ones(size(theta));
    xyz = [vec(X), vec(Y), vec(Z)];
    cxyz = real(sqrtm(Sigma))*xyz' + mu;
    cx = reshape(cxyz(1,:),size(X));
    cy = reshape(cxyz(2,:),size(Y));
    cz = reshape(cxyz(3,:),size(Z));
%     [X,Y,Z] = meshgrid(cx,cy,cz);
%     plot3(cx,cy,cz,'.')
    h = surf(cx,cy,cz,col_idx*ones(size(X)),'EdgeColor','none','HandleVisibility','off');%,'FaceColor','c');
end


end
