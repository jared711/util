function [value,isterminal,direction] = ef_distSec(et, X, rval)
% function [value,isterminal,direction] = ef_distSec(et, X, rval)

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
% 04/06/2021
% Jared T. Blanchard
%   adapted from ef_collideSec
% 
% Brian D. Anderson
% bdanders@usc.edu
% University of Southern California
% Los Angeles, CA
% 
% Jared T. Blanchard
% jared711@stanford.edu

global SEC mu RUNIT

if nargin < 3;  rval = SEC.radius/RUNIT;    end

% compute radial distance
p           = [1-mu;0;0];
rrel        = X(1:3) - p;
rnorm       = (rrel.' * rrel)^.5;
value       = rnorm - rval;
direction   = 0;
isterminal  = 1;  % stop the integration