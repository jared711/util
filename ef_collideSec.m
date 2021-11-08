function [value,isterminal,direction] = ef_collideSec(et,X)
% function [value,isterminal,direction] = ef_collideSec(et,X)

% inputs:
% t         :time [scalar]
% X         :state [6x1]
% rval      :desired trigger radius value [scalar]
% 
% outputs:
% value     :value of plane offset [scalar]
% isterminal:whether to terminate integration [scalar]
% direction :directional trigger [scalar]
% 
% LOG
% 05/03/2017
% Brian D. Anderson   
%   Original Code.
% 
% Brian D. Anderson
% bdanders@usc.edu
% University of Southern California
% Los Angeles, CA

global SEC mu RUNIT
rval = SEC.radius/RUNIT;
% compute radial velocity
p           = [1-mu;0;0];
rrel        = X(1:3) - p;
rnorm       = (rrel.' * rrel)^.5;
value       = rnorm - rval;
direction   = 0;
isterminal  = 1;  % stop the integration