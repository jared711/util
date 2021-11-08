function [C, U] = jacobi_constant(rv, mu, conv)
%[C, U] = jacobi_constant(rv, mu, conv)
%Returns the Jacobi Constant of a given state in the CR3BP
%If using more than one state, use jacobi_constants(rv, mu, conv)
%Inputs:
%   rv      =   (6x1)       state [rx; ry; rz; vx; vy; vz] or
%               (4x1)       state [rx; ry; vx; vy]
%   mu      =   (scalar)    gravitational parameter mu = m2/(m1+m2)
%   conv    =   (boolean)   convention mu(1-mu) {0}
%                           if conv == 1, C = C + mu(1-mu)
%Outputs:
%   C       =   (scalar)    Jacobi Constant of state in CR3BP
%   U       =   (scalar)    Augmented Potential (normally not used)

if nargin < 3;  conv = 0;   end
if nargin < 2;  global mu;  end

if ~iscolumn(rv)
    rv = rv';
end

if length(rv) == 6
    r = rv(1:3);
    r1 = r - [-mu; 0; 0];
    r2 = r - [1-mu; 0; 0];
    v = rv(4:6);
elseif length(rv) == 4
    r = rv(1:2);
    r1 = r - [-mu; 0];
    r2 = r - [1-mu; 0];
    v = rv(3:4);
else
    error('input state is not correct dimension: should be 6x1 or 4x1')
end

x = r(1);
y = r(2);
U = -(x^2 + y^2)/2 - (1-mu)/norm(r1) - mu/norm(r2);
if conv
    U = U - mu*(1-mu)/2;
end
C = -2*U - v'*v;

end

%Changelog
%Date               Programmer              Action
%08/08/2019         Jared T. Blanchard      file created
