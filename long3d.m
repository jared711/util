function lam = long3d(X,p)
% function lam = long3d(X,p)
% 
% computes longitude of 3D spatial state.

% inputs:
% X         :state [Nx6]
% p         :coordinate point defining center of reference [1x3] {[0,0,0]}
% 
% outputs:
% lam       :longitude [scalar] (rad)
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
lam = atan2(rr(:,2),rr(:,1));