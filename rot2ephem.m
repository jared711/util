function [rv_ephem, et] = rot2ephem(rv_rot, t, et0, mu, method, prim, sec, obs)
%ROT2EPHEM Converts from the rotating frame, nondimensional coordinates
%into the ephemeris J2000 frame with dimensional coordinates. Requires mice
% 
% [rv_ephem, et] = ROT2EPHEM(rv_rot, t, et0, mu, method, prim, sec, obs)
% 
% Inputs:   rv_rot (Nxn) [NON] dimensionless state 
%           t (Nx1) [NON] dimensionless time
%           et0 (scalar) [sec] initial ephemeris time, measured from 12:00:00 Jan 1, 2000           
%           mu (scalar) [NON] mass parameter
%           method (string) [] 'variable' or 'fixed' {'fixed'}
%           prim (string) [] primary body name {'earth'}
%           sec (string) [] secondary body name {'moon'}
%           obs (string) [] the observing body in the ephemeris model {1}
% 
% Outputs:  rv_ephem (Nxn) [km; km/s] dimensional position and velocity with respect to the central body 
% 
% See also: 

% Author: Jared Blanchard 	Date: 2023/11/06 15:47:22 	Revision: 0.1 $

% p = inputParser;
% addOptional(p,'method', 'fixed', @isstring)
% parse(p,varargin{:})
% method = p.Results.method;

if nargin < 8;  obs = 1;            end
if nargin < 7;  sec = 'moon';       end
if nargin < 6;  prim = 'earth';     end
if nargin < 5;  method = 'fixed';   end
if nargin < 4;  et0 = 0;            end

[N,n] = size(rv_rot);
if n ~= 7 && n~= 6 && n~= 3 && N ~= 42
    if N == 7 || N == 6 || N == 3 || N == 42 
        rv_rot = rv_rot';
        [N,n] = deal(n,N);
    else
        error("rv_rot must be 7XN, 6xN, 3xN, or 42xN")
    end     
end

rv_ephem = zeros(N,n);
et = zeros(N,1);

state_1_2 = cspice_spkezr(sec, et0, 'J2000', 'NONE', prim); % vector pointing from primary body to secondary body
rho_1_2 = state_1_2(1:3);
rho_1_2_dot = state_1_2(4:6);
omega = cross(rho_1_2, rho_1_2_dot)/norm(rho_1_2)^2;% [rad/sec]
l_star = norm(rho_1_2); % [km]
t_star = 1/norm(omega); % [sec]
v_star = l_star/t_star; % [km/s]

if strcmp(method,"fixed")
    for i = 1:N
        state_1_2 = cspice_spkezr(sec, et0 + t(i)*t_star, 'J2000', 'NONE', prim); % vector pointing from primary body to secondary body
        rho_1_2 = state_1_2(1:3);
        rho_1_2_dot = state_1_2(4:6);
        omega = cross(rho_1_2, rho_1_2_dot)/norm(rho_1_2)^2;% [rad/sec]
        x_hat = unit(rho_1_2);
        z_hat = unit(omega);
        y_hat = cross(z_hat, x_hat);
        R = [unit(x_hat)'; unit(y_hat)'; unit(z_hat)']; % rotation matrix from inertial to rotating frame
        
        r = rv_rot(i,1:3)';
        r_dot = rv_rot(i,4:6)';
        if obs == 1
            r1 = r - [-mu;0;0];
            r1_dot = r_dot;
            rho1 = l_star*(R'*r1);
            rho1_dot = v_star*(R'*r1_dot) + cross(omega,rho1);
            rv_ephem(i,:) = [rho1', rho1_dot'];
        elseif obs == 2
            r2 = r - [1-mu;0;0];
            r2_dot = r_dot;
            rho2 = l_star*(R'*r2);
            rho2_dot = v_star*(R'*r2_dot) + cross(omega,rho2);
            rv_ephem(i,:) = [rho2', rho2_dot'];
        else
            error('obs should be 1 or 2')
        end  
        
        et(i) = et0 + t(i)*t_star;
    end
elseif strcmp(method, "variable")
    for i = 1:N
        state_1_2 = cspice_spkezr(sec, et0 + t(i)*t_star, 'J2000', 'NONE', prim); % vector pointing from primary body to secondary body
        rho_1_2 = state_1_2(1:3);
        rho_1_2_dot = state_1_2(4:6);
        omega = cross(rho_1_2, rho_1_2_dot)/norm(rho_1_2)^2;% [rad/sec]
        l_star = norm(rho_1_2); % [km]
        t_star = 1/norm(omega); % [sec]
        v_star = l_star/t_star; % [km/s]
        x_hat = unit(rho_1_2);
        z_hat = unit(omega);
        y_hat = cross(z_hat, x_hat);
        R = [unit(x_hat)'; unit(y_hat)'; unit(z_hat)']; % rotation matrix from inertial to rotating frame
        
        r = rv_rot(i,1:3)';
        r_dot = rv_rot(i,4:6)';

        if obs == 1
            r1 = r - [-mu;0;0];
            r1_dot = r_dot;
            rho1 = l_star*(R'*r1);
            rho1_dot = v_star*(R'*r1_dot) + cross(omega,rho1);
            rv_ephem(i,:) = [rho1', rho1_dot'];
        elseif obs == 2
            r2 = r - [1-mu;0;0];
            r2_dot = r_dot;
            rho2 = l_star*(R'*r2);
            rho2_dot = v_star*(R'*r2_dot) + cross(omega,rho2);
            rv_ephem(i,:) = [rho2', rho2_dot'];
        else
            error('obs should be 1 or 2')
        end  

        et(i) = et0 + t(i)*t_star;
    end
else
    error('method should be "fixed" or "variable", "%s" was given',method)

end
