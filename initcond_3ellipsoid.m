function [rvs] = initcond_3ellipsoid(rv0,a,b,c,d,varargin)
%INITCOND_3ELLIPSOID Summary of this function goes here
% 
% [rvs] = INITCOND_3ELLIPSOID(rv0,a,b,c,d,varargin)
% 
% Inputs:   rv0 (6x1) [NON] initial condition
%           a (scalar) [NON] x semi-major axis
%           b (scalar) [NON] y semi-major axis
%           c (scalar) [NON] z semi-major axis
%           d (scalar) [NON] zdot semi-major axis
%           varargin
%               C (scalar) [NON] Jacobi constant {C(rv0)}
%               N (int) []  number of points to sample {100}
%               mu (scalar) [NON] CR3BP mass parameter {global mu}
% 
% Outputs:  rvs (6xN) [units] description 
% 
% See also: 

% Author: Jared Blanchard 	Date: 2023/08/29 09:38:35 	Revision: 0.1 $

p = inputParser;
addOptional(p,'C',[])
addOptional(p,'N', 100, @(x) validateattributes(x,"numeric","integer"))
% addOptional(p,'mu', []) % trying to make mu an optional argument causes a warning saying the local variable is changed to match the global, which won't be allowed in future versions. Just don't even worry about it.
parse(p,varargin{:})
C = p.Results.C;
N = p.Results.N;
% mu = p.Results.mu;

% if isempty(mu); global mu;                  end
if isempty(C);  C = jacobi_constant(rv0);   end

x0 = rv0(1);    y0 = rv0(2);    z0 = rv0(3);    % parse rv0 into individual variables
xdot0 = rv0(4); ydot0 = rv0(5); zdot0 = rv0(6);
theta_xy = atan2(ydot0,xdot0); % angle of velocity in xy plane
    

rvs = zeros(6,N); % initialize sampled states as array of zeros
for ii = 1:N
    xyzzdot = randn(4,1); % random point centered at origin
    xyzzdot = xyzzdot/norm(xyzzdot); % unit 3-sphere
    xyzzdot = [a;b;c;d].*xyzzdot; % stretched into ellipsoid
    xyzzdot = [x0;y0;z0;zdot0] + xyzzdot; % centered around rv0
    
    x = xyzzdot(1); y = xyzzdot(2); z = xyzzdot(3);
    zdot = xyzzdot(4);

% just doing a 2sphere
%     xyz = randn(3,1); % random point centered at origin
%     xyz = xyz/norm(xyz); % unit 3-sphere
%     xyz = [a;b;c].*xyz; % stretched into ellipsoid
%     xyz = [x0;y0;z0] + xyz; % centered around rv0
% 
%     x = xyz(1); y = xyz(2); z = xyz(3);
%     zdot = 0;
    
    rdot = vmag_CR3BP([x;y;z],C);
    if ~isreal(rdot);   error("Ellipsoid semi-major axes too large, imaginary velocity magnitude"); end
    if zdot^2 > rdot^2; error("z-component of velocity semi-major axis too large"); end
    rdot_xy = sqrt(rdot^2 - zdot^2);
    
    xdot = rdot_xy*cos(theta_xy);
    ydot = rdot_xy*sin(theta_xy);
    
    rvs(:,ii) = [x;y;z;xdot;ydot;zdot];
end

% need some method to check if we'll be moving into the forbidden region
% A = diag([1/a^2, 1/b^2, 1/c^2, 0, 0, 1/d^2]);


end
