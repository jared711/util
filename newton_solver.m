function [x] = newton_solver(f, fprime, x0, h, time_limit, epsilon)
%NEWTON_SOLVER Solves the equation f(x) = 0 using Newton's iterative method
%with x0 as the initial guess
% 
% [x] = NEWTON_SOLVER(f,x0)
% 
% Inputs:   f (function)
%           x0 (scalar) initial guess of variable to be solved for
% 
% Outputs:  x (scalar) variable to be solved for
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/10/04 08:24:44 	Revision: 0.1 $

if nargin < 6;  epsilon = 1e-12;    end
if nargin < 5;  time_limit = 1;     end
if nargin < 4;  h = 1e-12;          end

x = x0;

fprime_f = @(y) (f(y+h) - f(y))/h; % forward difference
fprime_b = @(y) (f(y) - f(y-h))/h; % backward difference
fprime_c = @(y) (f(y+h/2) - f(y-h/2))/h; % central difference

if isempty(fprime)
    fprimes = {fprime_f,fprime_b,fprime_c};
else
    fprimes = {fprime,fprime_f,fprime_b,fprime_c};
end
prime_idx = 1;
fprime = fprimes{1};

overlap = 0;

while fprime(x) == 0
    prime_idx = prime_idx + 1;
    if prime_idx > length(fprimes)
        if overlap
            warning('All derivative methods yield 0')
            break
        end
        prime_idx = 1;
        overlap = 1; 
    end
    fprime = fprimes{prime_idx};    
end
dx = f(x)/fprime(x);

tic
while abs(dx) > epsilon    
    x = x - dx;
    while fprime(x) == 0
        prime_idx = prime_idx + 1;
        if prime_idx > length(fprimes)
            if overlap
                warning('All derivative methods yield 0')
                break
            end
            prime_idx = 1;
            overlap = 1; 
        end
        fprime = fprimes{prime_idx};    
    end
    dx = f(x)/fprime(x);
%     if toc > time_limit
%         warning("solver didn't converge")
%         break
%     end
end

end
