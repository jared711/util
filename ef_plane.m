function [value,isterminal,direction] = ef_plane(t,x,n,d)
% function [value,isterminal,direction] = compval(t,x,comp,val,DIR)
% 
% Event function for determining when state has passed through a plane
% defined by n'x = d. We stop when the state has passed through in the n
% direction

% inputs:
% t         :time [scalar]
% x         :state [Nx1]
% n         :normal vector to plane
% d         :constant value
% 
% outputs:
% value     :value of plane offset [scalar]
% isterminal:whether to terminate integration [scalar]
% direction :directional trigger [scalar]

r = x(1:3);
value = dot(n,r) - d;
isterminal  = 1;            % stop the integration
direction   = 1;          % any direction