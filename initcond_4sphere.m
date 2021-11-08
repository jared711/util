function [rvs, N, N_r, N_v] = initcond_4sphere(rv0, r_radius, v_radius, N_r, N_v, mu)
%INITCOND_4SPHERE generates a set of initial conditions near a landing
%site that is homeomorphic to a 4sphere, the constraints being 
% |r-r0| = r_radius and |v-vmag*(v0/|v0|)| = v_radius, where vmag is a 
% scalar such that jacobi_constant([r;vmag*(v0/|v0|)]) = C0, assuming the
% CR3BP. Note that this will produce a range of jacobi constants.
% 
% [rvs, N, N_r, N_v] = INITCOND_4SPHERE(rv0, r_radius, v_radius, N_r, N_v, mu)
% 
% Inputs: 
%           rv0 (6x1) [] nondimensional state vector at landing/periapsis
%           r_radius (scalar) [] nondimensional radius of sphere about r0
%           v_radius (scalar) [] nondimensional radius of sphere about v0
%           N_r (scalar) [] number of distinct positions
%           N_v (scalar) [] number of distinct velocities
%           mu (scalar) [] nondimensional CR3BP mass parameter
% 
% Outputs: 
%           rvs (6xN) [] nondimensional state vectors of initial conditions
%           N (scalar) total number of initial conditions
%           N_r (scalar) updated (actual) number of distinct positions
%           N_v (scalar) updated (actual) number of distinct velocities
% 
% See also: 

% Author: Jared Blanchard 	Date: 2021/10/27 09:33:16 	Revision: 0.1 $
fprintf('initcond_4sphere\n')
tic

if nargin < 6;  global mu;  end
if isempty(mu); mu = 2.528017682687079e-05; end % Jupiter/Europa system
if nargin < 5;  N_v = 10;   end
if nargin < 4;  N_r = 10;   end
if nargin < 3;  v_radius = 1e-5;end % unitless distance from v0
if nargin < 2;  r_radius = 1e-5;end % unitless distance from r0

C0 = jacobi_constant(rv0, mu); % jacobi constant of landing/periapsis state

r0 = rv0(1:3); %r0 is at the landing site
v0 = rv0(4:6); %v0 is landing velocity

% Create funnel initial positions
rs = desernoSphere(N_r)'; % generates a unit sphere of points
N_r = length(rs); % update based on desernoSphere output (can change to fit better)
rs = r_radius*rs + r0; % scale points by rmag and translate to center around r0

vmag = vmag_CR3BP(rs, C0, mu); % compute velocity magnitude for C=C0 constraint

vs = desernoSphere(N_v)'; % generates a unit sphere of points
vs = v_radius*vs;
N_v = length(vs);

N = N_r*N_v;  % total number of trajectories in funnel
rvs = zeros(6,N);
for i = 1:N_r
    idx = (i-1)*N_v + 1;
    r_block = rs(:,i)*ones(1,N_v);
    v_block = vs + vmag(i)*v0/norm(v0);
    rvs(:, idx:idx+N_v-1) = [r_block; v_block];
end

fprintf('Generated  %i initial conditions in %d seconds\n', N, toc)

end
