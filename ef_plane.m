function [value,isterminal,direction] = ef_plane(t,x,n,d,isterminal,direction)
% function [value,isterminal,direction] = ef_plane(t,x,n,d,isterminal,direction)
% 
% Event function for determining when state has passed through a plane
% defined by n'x = d. We stop when the state has passed through in the n
% direction
% 
% inputs:
% t         :time [scalar]
% x         :state [Nx1]
% n         :normal vector to plane
% d         :constant value
% isterminal:stop the integration {1}
% direction :1 stops when moving from positive to negative {1}
%           :-1 stops when moving from negative to positive
% 
% outputs:
% value     :value of plane offset [scalar]
% isterminal:whether to terminate integration [scalar]
% direction :directional trigger [scalar]
if nargin < 6;  direction = 1;      end
if nargin < 5;  isterminal  = 1;    end % stop the integration

r = x(1:3);
value = dot(n,r) - d;
