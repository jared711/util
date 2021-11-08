function rv_dot = hill(t, rv, mu, N)
%HILL Equations of motion for the Hill model
% 
% rv_dot = HILL(t, rv, mu, N)
% 
% Inputs:
%           t = [sec] integration time
%           rv (6x1) [km; km/s] state
% Outputs: 
%           rv_dot (6x1) [km/s; km/s^2] time derivative of state
% 
% See also: 

% Author: Jared Blanchard 	Date: 2021/09/23 12:53:01 	Revision: 0.1 $
% Equations pulled from B. F. Villac and D. J. Scheeres, “Escaping trajectories in the Hill three-body problem and applications,” J. Guid. Control. Dyn., vol. 26, no. 2, pp. 224–232, 2003, doi: 10.2514/2.5062.

if nargin < 4;  N = 1;  end
if nargin < 3;  mu = 1; end

if ~iscolumn(rv);   rv = rv';   end
if ~iscolumn(rv);   error('rv should be a column vector');  end

x = rv(1);  y = rv(2);  z = rv(3);
vx = rv(4); vy = rv(5); vz = rv(6);
r3 = norm([x;y;z])^3;

rv_dot = zeros(6,1);
rv_dot(1:3) = [vx;vy;vz];
rv_dot(4) = 2*N*vy + 3*N^2*x - mu*x/r3;
rv_dot(5) = -2*N*vx - mu*y/r3;
rv_dot(6) = -N^2*z - mu*z/r3;

end
