function [value,isterminal,direction,extra_cond] = ycross(t,X,side,DIR)
% function [value,isterminal,direction] = compval(t,X,comp,val,DIR)
% 
% Event function for determining when state component meets a specific
% value.

% inputs:
% t         :time [scalar]
% X         :state [Nx1]
% side      :side of X axis [scalar] {0}
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



if nargin < 4   DIR = 0;    end     %default to intersect in either direction
if nargin < 3   side = 0;   end     %default either side of the x axis

if sign(X(1)) == side
    value       = X(2);% compute distance from plane
else
    value = 1;
end
isterminal  = 1;            % stop the integration
direction   = DIR;          % any direction
extra_cond = 0;