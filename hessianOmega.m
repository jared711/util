function [H] = hessianOmega(r, mu)
%HESSIANOMEGA compute the Hessian of the CR3BP potential function Omega
%with respect to r
% 
% [H] = HESSIANOMEGA(r, mu)
% 
% Inputs: 
%           r (3x1) [] position of state
%           mu (scalar) [] mass parameter
% 
% Outputs: 
%           H (3x3) [] Hessian of Omega w.r.t. r
% 
% See also: 

% Author: Jared Blanchard 	Date: 2021/10/29 17:35:28 	Revision: 0.1 $

if nargin < 2;  global mu;  end
if isempty(mu); mu = 2.528017682687079e-05; end % Jupiter-Europa

x = r(1);
y = r(2);
z = r(3);

r1 = norm([x + mu,      y, z]);
r2 = norm([x - 1 +  mu, y, z]);
r13 = r1^3;
r15 = r1^5;
r23 = r2^3;
r25 = r2^5;

omgxx = 1 - (1-mu)*(1/r13 - 3*(x + mu)^2/r15) - mu*(1/r23 - 3*(x - 1 + mu)^2/r25);
omgxy = 3*(1-mu)*(x + mu)*y/r15 + 3*mu*(x - 1 + mu)*y/r25;
omgxz = 3*(1-mu)*(x + mu)*z/r15 + 3*mu*(x - 1 + mu)*z/r25;
omgyy = 1 - (1-mu)*(1/r13 - 3*y^2/r15) - mu*(1/r23 - 3*y^2/r25);
omgyz = 3*(1-mu)*y*z/r15 + 3*mu*y*z/r25;
omgzz = - (1-mu)*(1/r13 - 3*z^2/r15) - mu*(1/r23 - 3*z^2/r25);

H = [omgxx omgxy omgxz;
     omgxy omgyy omgyz;
     omgxz omgyz omgzz]; 

end
