function [rvs, N, N_r, N_v] = initcond_2sphere(rv0, alpha_r, alpha_v, N_r, N_v, mu)
%INITCOND_2SPHERE generates a set of initial conditions near a landing
%site that is homeomorphic to a 2sphere, the constraints being C = C0,
%|r-r0| = r_radius, |r-c| = R2 and v*'v0 = |v||v0|cos(alpha), assuming the 
%CR3BP. In other words, all intial conditions have the same jacobi constant
%as the landing/periapsis state, they are constrained in position space to
%a ring about the landing/periapsis position on the surface of the
%secondary body, and they are constrained in velocity space to a ring about
%the landing velocity.
% 
% [rvs, N] = INITCOND_2SPHERE(rv0, alpha, N_r, N_v, mu)
% 
% Inputs: 
%           rv0 (6x1) [] nondimensional state vector at landing/periapsis
%           alpha_r (scalar) [deg] cone angle of ring on surface of secondary
%           alpha_v (scalar) [deg] cone angle measured from v0 direction
%           N_r (scalar) [] desired number of distinct positions
%           N_v (scalar) [] desired number of distinct velocities
%           mu (scalar) [] nondimensional CR3BP mass parameter
% 
% Outputs: 
%           rvs (6xN) [] nondimensional state vectors of initial conditions
%           N (scalar) [] number of initial conditions
%           N_r (scalar) updated (actual) number of distinct positions
%           N_v (scalar) updated (actual) number of distinct velocities
% 
% See also: 

% Author: Jared Blanchard 	Date: 2021/11/2 016:08:52 	Revision: 0.1 $
fprintf('initcond_2sphere\n')
tic

if nargin < 4;  global mu;  end
if isempty(mu); mu = 2.528017682687079e-05; end % Jupiter/Europa system
if isrow(rv0);  rv0 = rv0'; end % make sure rv0 is a column vector

C0 = jacobi_constant(rv0, mu); % jacobi constant of landing/periapsis state

r0 = rv0(1:3); %r0 is at the landing site
v0 = rv0(4:6); %v0 is landing velocity
[theta0,phi0] = cart2sph(v0(1),v0(2),v0(3)); % compute the spherical coordinates of the velocity vector

% Create funnel initial positions
c = [1-mu;0;0];
r = r0 - c;
rs = sphericalRing(c,r,N_r,alpha_r)';

% create funnel velocities at each position
vmag = vmag_CR3BP(rs, C0, mu); % compute velocity magnitude for C=C0 constraint
alpha_v = deg2rad(alpha_v); % opening angle of the cone
[x_cone, y_cone, z_cone] = sph2cart(linspace(2*pi/N_v,2*pi,N_v), pi/2 - alpha_v, ones(1,N_v)); % generate a unit cone
vs = rotz(theta0)*roty(pi/2 - phi0)*[x_cone; y_cone; z_cone]; % rotate cone to be centered about v0

N = N_r*N_v;  % total number of trajectories in funnel
rvs = zeros(6,N); % initialize rvs
for i = 1:N_r
    idx = (i-1)*N_v + 1;
    rvs(:, idx:idx+N_v-1) = [rs(:,i)*ones(1,N_v); vs*vmag(i)];
end

fprintf('Generated  %i initial conditions in %d seconds\n', N, toc)

end
