function [C, U] = jacobi_constants(rv, mu, conv)
%[C, U] = jacobi_constants(rv, mu, conv)
%Returns an array of Jacobi Constants of given states in the CR3BP
%Inputs:
%   rv      =   (6xN)       state [rx; ry; rz; vx; vy; vz] or
%               (4xN)       state [rx; ry; vx; vy]
%   mu      =   (scalar)    gravitational parameter mu = m2/(m1+m2)
%   conv    =   (boolean)   convention mu(1-mu)
%                           if conv == 1, C = C + mu(1-mu)
%Outputs:
%   C       =   (1xN)       Jacobi Constants of states in CR3BP
%   U       =   (1xN)       Augmented Potentials (normally not used)

if nargin < 3;  conv = 0;   end
if nargin < 2;  global mu;  end

rv = rv_sizeCheck(rv);
[n,m] = size(rv);

if n == 6 || n == 4 % rv is of the correct dimensions been given correct dimensions
    C = zeros(1,m);
    for i = 1:m
        [C(i),U(i)] = jacobi_constant(rv(:,i), mu, conv);
    end
elseif m == 6 || m == 4
    C = zeros(1,n);
    for i = 1:n
        [C(i),U(i)] = jacobi_constant(rv(i,:)', mu, conv);
    end
else
    error('input state is not correct dimension: should be 6xN or 4xN')
end

%Changelog
%Date           Programmer              Action
%08/08/2019     Jared T. Blanchard      Code written
        