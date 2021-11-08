function rr = r2d(xx,p)
% function rr = r2d(xx,p)
% 
% Radial distance relative to a chosen center. 2D state assumed.

% inputs:
% xx        :state array [Nx4]
% p         :coordinate point defining center of reference [1x2] {[0,0]}
% 
% outputs:
% rr        :radial distance to reference point [Nx1]
% 
% LOG
% 12/06/2016
% Brian D. Anderson   
%   Original Code.
% 
% Brian D. Anderson
% bdanders@usc.edu
% University of Southern California
% Los Angeles, CA


% default to origin as coordinate
if nargin < 2;  p       = zeros(1,2);   end;

% compute radial velocity
npts        = size(xx,1);
rrel        = xx(:,1:2) - repmat(p,npts,1);
rr          = (rrel(:,1).^2 + rrel(:,2).^2).^.5;