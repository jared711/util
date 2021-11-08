function [lambda, tt, xx] = lyapExp(rv0, dt, tf)
%LYAPEXP Calculates the local lyapunov exponent for a trajectory in the
%CR3BP from time 0 to t.
% 
% [lambda] = LYAPEXP(PHI, t)
% 
% Inputs:
%   PHI     [6x6] state transition matrix of trajectory from 0 to t
%   t       (scalar) time of integration
% 
% Outputs:
%   lambda  (scalar) local lyapunov exponent
% 
% See also: List related files here
if ~iscolumn(rv0);      rv0 = rv0'; end
if tf < 0 && dt > 0;    dt = -dt;   end
if tf > 0 && dt < 0;    error('negative dt'); end

PHI0 = eye(6,6);
y0 = [PHI0(:);rv0];

[tt,xx] = ode78e(@(t,x) CR3BPbrian(t,x),0,tf,rv0,1e-12);
N = length(tt);

PHI_dt = cell(N,1);
lambda = zeros(N,1);
for i = 1:N
    y0 = [PHI0(:);xx(i,:)'];
    [~,xx_dt] = ode78e(@(t,y) CR3BP_STM(t,y),0,dt,y0,1e-12,0);
    PHI_dt = reshape(xx_dt(end,1:36),6,6);
    A = sqrtm(PHI_dt*PHI_dt');
    E = eig(A);
    Emax = max(E);
    lambda(i) = 1/dt * log(Emax);
end

% Author: Jared Blanchard 	Date: 2020/08/06 17:35:18 	Revision: 0.1 $

end
