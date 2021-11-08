function [value,isterminal,direction] = ef_rval3d(t,X,rval,p,DIR,stop)
% function [value,isterminal,direction] = ef_rval3d(t,X,r,p,DIR,stop)
% 
% Event function for determining when a state reaches a radial distance
% relative to a chosen center. 3D state assumed.
% 
% inputs:
% t         :time [scalar]
% X         :state [6x1]
% rval      :desired radius value [scalar]
% p         :coordinate point defining center of reference [3x1] {[0,0]}
% DIR       :desired directionality [scalar] [+1,0 or -1] {0}
% stop      :switch to stop integration at event trigger [1 or 0] {1}
% 
% outputs:
% value     :value of plane offset [scalar]
% isterminal:whether to terminate integration [scalar]
% direction :directional trigger [scalar]

% LOG
% 03/07/2016
% Brian D. Anderson   
%   Original Code.
% 02/12/2018
% Brian D. Anderson   
%   Added optional switch for stopping.
% 
% Brian D. Anderson
% bdanders@usc.edu
% University of Southern California
% Los Angeles, CA


% default to origin as coordinate
if nargin < 6;  stop    = 1;            end
if nargin < 5;  DIR     = 0;            end
if nargin < 4;  p       = zeros(3,1);   end

% compute radial velocity
rrel        = X(1:3) - p;
rnorm       = (rrel.' * rrel)^.5;
value       = rnorm - rval;
direction   = DIR;
isterminal  = stop;  % stop the integration?