function del = lat3d(X,p)
% function del = lat3d(X,p)
% 
% computes latitude of spatial state.

% inputs:
% X         :state [Nx6]
% p         :coordinate point defining center of reference [1x3] {[0,0,0]}
% 
% outputs:
% del       :latitude [scalar] (rad)
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
rn  = (rr(:,1).^2 + rr(:,2).^2 + rr(:,3).^2).^.5;
del = asin(rr(:,3)./rn);