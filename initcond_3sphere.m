function [rvs, N, N_r, N_v] = initcond_3sphere(rv0, r_radius, alpha, N_r, N_v, mu)
%INITCOND_3SPHERE generates a set of initial conditions near a landing
%site that is homeomorphic to a 3sphere, the constraints being C = C0,
%|r-r0| = r_radius and v*'v0 = |v||v0|cos(alpha), assuming the CR3BP.
% 
% [rvs, N, N_r, N_v] = INITCOND_3SPHERE(rv0, r_radius, alpha, N_r, N_v, mu)
% 
% Inputs: 
%           rv0 (6x1) [] nondimensional state vector at landing/periapsis
%           r_radius (scalar) [] nondimensional radius of sphere about r0
%           alpha (scalar) [deg] cone angle measured from v0 direction
%           N_r (scalar) [] desired number of distinct positions
%           N_v (scalar) [] desired number of distinct velocities
%           mu (scalar) [] nondimensional CR3BP mass parameter
% 
% Outputs: 
%           rvs (6xN) [] nondimensional state vectors of initial conditions
%           N (scalar) total number of initial conditions
%           N_r (scalar) updated (actual) number of distinct positions
%           N_v (scalar) updated (actual) number of distinct velocities
% 
% See also: 

% Author: Jared Blanchard 	Date: 2021/10/27 08:59:52 	Revision: 0.1 $
fprintf('initcond_3sphere\n')
tic

if nargin < 6;  global mu;  end
if isempty(mu); mu = 2.528017682687079e-05; end % Jupiter/Europa system
if nargin < 5;  N_v = 10;   end
if nargin < 4;  N_r = 10;   end
if nargin < 3;  alpha = 5;  end % degrees
if nargin < 2;  r_radius = 1e-5;end % unitless distance from r0

C0 = jacobi_constant(rv0, mu); % jacobi constant of landing/periapsis state

r0 = rv0(1:3); %r0 is at the landing site
v0 = rv0(4:6); %v0 is landing velocity
[theta0,phi0] = cart2sph(v0(1),v0(2),v0(3)); % compute the spherical coordinates of the velocity vector

% Create funnel initial positions
rs = desernoSphere(N_r)'; % generates a unit sphere of points
N_r = length(rs); % update based on desernoSphere output (can change to fit better)
rs = r_radius*rs + r0; % scale points by rmag and translate to center around r0

% create funnel velocities at each position
vmag = vmag_CR3BP(rs, C0, mu); % compute velocity magnitude for C=C0 constraint
alpha = deg2rad(alpha); % opening angle of the cone
[x_cone, y_cone, z_cone] = sph2cart(linspace(2*pi/N_v,2*pi,N_v), pi/2 - alpha, ones(1,N_v)); % generate a unit cone
vs = rotz(theta0)*roty(pi/2 - phi0)*[x_cone; y_cone; z_cone]; % rotate cone to be centered about v0

N = N_r*N_v;  % total number of trajectories in funnel
rvs = zeros(6,N); % initialize rvs
for i = 1:N_r
    idx = (i-1)*N_v + 1;
    rvs(:, idx:idx+N_v-1) = [rs(:,i)*ones(1,N_v); vs*vmag(i)];
end

fprintf('Generated  %i initial conditions in %d seconds\n', N, toc)

end
