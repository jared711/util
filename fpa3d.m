function phi = fpa3d(X,p)
% function phi = fpa3d(X,p)
% 
% computes flight path angle of 3D spatial state.

% inputs:
% X         :state [Nx6]
% p         :coordinate point defining center of reference [1x3] {[0,0,0]}
% 
% outputs:
% phi       :flight path angle [scalar] (rad)
% 
% LOG
% 04/13/2016
% Brian D. Anderson   
%   Original Code.
% 
% Brian D. Anderson
% bdanders@usc.edu
% University of Southern California
% Los Angeles, CA


npts = size(X,1);

pp  = repmat(p,npts,1);
rr  = X(:,1:3) - pp;
vv  = X(:,4:6);
rrn = vanorm(rr,'row');
vvn = vanorm(vv,'row');
% phi = pi/2 - acos(diag(vv*rr.')./(rrn.*vvn));
phi = pi/2 - acos(sum(vv.*rr,2)./(rrn.*vvn));