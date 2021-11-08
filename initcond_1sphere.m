function [rvs, N] = initcond_1sphere(rv0, alpha, N, mu)
%INITCOND_1SPHERE generates a set of initial conditions near a landing
%site that is homeomorphic to a 1sphere, the constraints being C = C0,
%|r-r0| = r_radius, |r-c| = R2 and v*'v0 = |v||v0|, assuming the CR3BP. In
%other words, all intial conditions have the same jacobi constant as the
%landing/periapsis state, they are constrained in position space to a ring
%about the landing/periapsis position on the surface of the secondary body,
%and they must have a velocity parallel to the landing/periapsis velocity.
% 
% [rvs, N] = INITCOND_1SPHERE(rv0, r_radius, R2, N, mu)
% 
% Inputs: 
%           rv0 (6x1) [] nondimensional state vector at landing/periapsis
%           alpha (scalar) [deg] cone angle of ring on surface of secondary
%           N (scalar) [] desired number of initial conditions
%           mu (scalar) [] nondimensional CR3BP mass parameter
% 
% Outputs: 
%           rvs (6xN) [] nondimensional state vectors of initial conditions
%           N (scalar) [] number of initial conditions
% 
% See also: 

% Author: Jared Blanchard 	Date: 2021/10/27 011:08:52 	Revision: 0.1 $

if nargin < 4;  global mu;  end
if isempty(mu); mu = 2.528017682687079e-05; end % Jupiter/Europa system
if nargin < 3;  N = 100;   end
if nargin < 2;  alpha = 5;  end % degrees
if isrow(rv0);  rv0 = rv0'; end % make sure rv0 is a column vector

C0 = jacobi_constant(rv0, mu); % jacobi constant of landing/periapsis state

r0 = rv0(1:3); %r0 is at the landing site
v0 = rv0(4:6); %v0 is landing velocity

% Create funnel initial positions
c = [1-mu;0;0];
r = r0 - c;
rs = sphericalRing(c,r,N,alpha)';

% create funnel velocity at each position
vmag = vmag_CR3BP(rs, C0, mu); % compute velocity magnitude for C=C0 constraint
vs = (v0*vmag)/norm(v0); 

% put position and velocity together
rvs = [rs; vs];

end
