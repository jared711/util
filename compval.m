function [value,isterminal,direction,extra_cond] = compval(t,X,comp,val,DIR)
% function [value,isterminal,direction] = compval(t,X,comp,val,DIR)
% 
% Event function for determining when state component meets a specific
% value.

% inputs:
% t         :time [scalar]
% X         :state [Nx1]
% comp      :component index
% val       :desired value of X(comp)
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



if nargin < 5
    DIR     = 0; %default to intersect in either direction
end

value       = X(comp) - val;% compute distance from plane
isterminal  = 1;            % stop the integration
direction   = DIR;          % any direction
extra_cond = 0;