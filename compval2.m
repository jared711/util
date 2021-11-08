function [value,isterminal,direction,extra_cond] = compval2(t,X,comp,val,DIR,comp2,val2,lessthan)
% 
% Event function for determining when state component meets a specific
% value.

% inputs:
% t         :time [scalar]
% X         :state [Nx1]
% comp      :component index
% val       :desired value of X(comp)
% DIR       :directional trigger [scalar] {0}
% comp2     :second component index
% val       :desired value of X(comp2)
% lessthan  :if TRUE, will set extra_cond to TRUE if compare X(comp2) < val2
%               otherwise, will compare X(comp2) >= val2
% 
% outputs:
% value     :value of plane offset [scalar]
% isterminal:whether to terminate integration [scalar]
% direction :directional trigger [scalar]
% extra_cond:
% 
% LOG
% 02/01/2016    
% Brian D. Anderson   
%   Original Code.
% 
% 03/01/2019
% Jared Blanchard
%   Created compval2 from compval
% 
% Brian D. Anderson
% bdanders@usc.edu
% University of Southern California
% Los Angeles, CA
%
% Jared Blanchard
% jared711@stanford.edu
% Stanford University
% Stanford, CA

extra_cond = 0;

if nargin < 8
    lessthan = 1;
    if nargin < 7
        val2 = 0;
    end
end

if lessthan*X(comp2) < val2
    extra_cond = 1;
end

if nargin < 6
    extra_cond = 1;
end

if nargin < 5
    DIR     = 0; %default to intersect in either direction
end

value       = X(comp) - val;% compute distance from plane
isterminal  = 1;            % stop the integration
direction   = DIR;          % any direction