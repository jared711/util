function [value,isterminal,direction,extra_cond] = ef_XZplane(t,X,DIR)
% function [value,isterminal,direction] = compval(t,X,comp,val,DIR)
% 
% Event function for determining when state component reaches XZ plane (+X
% half plane)

% inputs:
% t         :time [scalar]
% X         :state [Nx1]
% DIR       :directional trigger [scalar] {0}
% 
% outputs:
% value     :value of plane offset [scalar]
% isterminal:whether to terminate integration [scalar]
% direction :directional trigger [scalar]
% 
% LOG
% 02/01/2016    
% Brian D. Anderson   
%   Original Code.
% 
% Brian D. Anderson
% bdanders@usc.edu
% University of Southern California
% Los Angeles, CA


if nargin < 3
    DIR     = 0; %default to intersect in either direction
end

if X(1) < 0
    value = 0 % dummy value that never goes below zero
else 
    value = X(2)% compute distance from plane
end
isterminal  = 1;            % stop the integration
direction   = DIR;          % any direction
extra_cond = 0;