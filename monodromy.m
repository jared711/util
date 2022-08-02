function [PHI_T] = monodromy(rv0, T)
%MONODROMY computes the monodromy matrix of a periodic orbit in the CR3BP
% 
% [PHI_T] = MONODROMY(rv0, T)
% 
% Inputs:   rv0 [NON] (6x1) initial state of periodic orbit
%           T [NON] (scalar) period of periodic orbit
% 
% Outputs:  PHI_T [NON] (6x6) Monodromy matrix
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/04/25 17:23:14 	Revision: 0.1 $

PHI0 = reshape(eye(6),36,1);
if ~iscolumn(rv0)
    y0 = [PHI0; rv0'];
else
    y0 = [PHI0; rv0];
end

[~,xx] = ode78e(@(t,y) CR3BP_STM(t,y), 0, T, y0, 1e-12);

PHI = xx(:,1:36);
PHI_T = reshape(PHI(end,:),6,6);

end
