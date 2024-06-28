% compute the y of the zero velocity surface using simple newton method
function y = zvs_y(x,C,mu,tol)

if nargin < 4;  tol = 1e-12;    end
if nargin < 3;  global mu;      end

y = 0.02; % initial guess
dy = 100;
while dy > tol
    r1 = sqrt( (x+mu)^2 + y^2 );
    r2 = sqrt( (x-1+mu)^2 + y^2 );
    r13 = r1^3;
    r23 = r2^3;
    f = x^2 + y^2 + 2*(1-mu)/r1 + 2*mu/r2 - C; % this is the function I want to drive to zero
    f_prime = 2*y - 2*(1-mu)/r13 - 2*mu*y/r23; % derivative of the function
    dy = f/f_prime;
    y = y-dy;
end
% y
end