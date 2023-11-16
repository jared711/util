function [rv_rot, t] = ephem2rot(rv_ephem, et, mu, method, prim, sec, obs)
%EPHEM2ROT Converts from the ephemeris J2000 frame into the rotating frame
%with dimensionless coordinates. The ephemeris state is expected to be
%measured with respect to the primary body
% 
% [rv_rot, t] = EPHEM2ROT(rv_ephem, et, mu, method, prim, sec, obs)
% 
% Inputs:   rv_ephem (Nxn) [km; km/s] state in ephemeris J2000 frame with dimensional coordinates
%           et (Nx1) [sec] ephemeris time, measured from 12:00:00 Jan 1, 2000
%           mu (scalar) [NON] mass parameter
%           method (string) [] variable time or fixed time {'fixed'}
%           prim (string) [] primary body name {'earth'}
%           sec (string) [] secondary body name {'moon'}
%           obs (string) [] the observing body in the ephemeris model {1}
% 
% Outputs:  rv_rot (Nxn) [NON] state in rotating frame with dimensionless coordinates
%           t (Nx1) [NON] dimensionless time
% 
% See also: 

% Author: Jared Blanchard 	Date: 2023/11/06 16:09:42 	Revision: 0.1 $

% p = inputParser;
% addOptional(p,'method', 'fixed', @isstring)
% parse(p,varargin{:})
% method = p.Results.method;
if nargin < 7;  obs = 1;            end
if nargin < 6;  sec = 'moon';       end
if nargin < 5;  prim = 'earth';     end
if nargin < 4;  method = 'fixed';   end

[N,n] = size(rv_ephem);
if n ~= 7 && n~= 6 && n~= 3 && N ~= 42
    if N == 7 || N == 6 || N == 3 || N == 42 
        rv_ephem = rv_ephem';
        [N,n] = deal(n,N);
    else
        error("rv_ephem must be 7XN, 6xN, 3xN, or 42xN")
    end     
end

rv_rot = zeros(N,n);
t = zeros(N,1);

et0 = et(1);
state_1_2 = cspice_spkezr(sec, et0, 'J2000', 'NONE', prim); % vector pointing from primary body to secondary body
rho_1_2 = state_1_2(1:3);
rho_1_2_dot = state_1_2(4:6);
omega = cross(rho_1_2, rho_1_2_dot)/norm(rho_1_2)^2;% [rad/sec]
l_star = norm(rho_1_2); % [km]
t_star = 1/norm(omega); % [sec]
v_star = l_star/t_star; % [km/s]

if strcmp(method,"fixed")
    for i = 1:N
        state_1_2 = cspice_spkezr(sec, et(i), 'J2000', 'NONE', prim); % vector pointing from primary body to secondary body
        rho_1_2 = state_1_2(1:3);
        rho_1_2_dot = state_1_2(4:6);
        omega = cross(rho_1_2, rho_1_2_dot)/norm(rho_1_2)^2;% [rad/sec]
        x_hat = unit(rho_1_2);
        z_hat = unit(omega);
        y_hat = cross(z_hat, x_hat);
        R = [unit(x_hat)'; unit(y_hat)'; unit(z_hat)']; % rotation matrix from inertial to rotating frame
        
        if obs == 1
            rho1 = rv_ephem(i,1:3)';
            rho1_dot = rv_ephem(i,4:6)';
            r1 = (R*rho1)/l_star;
            r1_dot = (R*rho1_dot)/v_star - cross([0;0;1],r1);
            r = r1 + [-mu;0;0];
            r_dot = r1_dot;
            rv_rot(i,:) = [r', r_dot'];
        elseif obs == 2
            rho2 = rv_ephem(i,1:3)';
            rho2_dot = rv_ephem(i,4:6)';
            r2 = (R*rho2)/l_star;
            r2_dot = (R*rho2_dot)/v_star - cross([0;0;1],r2);
            r = r2 + [1-mu;0;0];
            r_dot = r2_dot;
            rv_rot(i,:) = [r', r_dot'];
        else
            error('obs should be 1 or 2')
        end 
        t(i) = (et(i) - et0)/t_star;
    end
elseif strcmp(method, "variable")
    for i = 1:N
        state_1_2 = cspice_spkezr(sec, et(i), 'J2000', 'NONE', prim); % vector pointing from primary body to secondary body
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
        
        if obs == 1
            rho1 = rv_ephem(i,1:3)';
            rho1_dot = rv_ephem(i,4:6)';
            r1 = (R*rho1)/l_star;
            r1_dot = (R*rho1_dot)/v_star - cross([0;0;1],r1);
            r = r1 + [-mu;0;0];
            r_dot = r1_dot;
            rv_rot(i,:) = [r', r_dot'];
        elseif obs == 2
            rho2 = rv_ephem(i,1:3)';
            rho2_dot = rv_ephem(i,4:6)';
            r2 = (R*rho2)/l_star;
            r2_dot = (R*rho2_dot)/v_star - cross([0;0;1],r2);
            r = r2 + [1-mu;0;0];
            r_dot = r2_dot;
            rv_rot(i,:) = [r', r_dot'];
        else
            error('obs should be 1 or 2')
        end 

%         t(i) = (et(i) - et(1))/t_star;
        if i == 1
            t(i) = 0; %(et(i) - et(1))/t_star;
        else
            t(i) = (et(i) - et(i-1))/t_star + t(i-1);
        end
       
    end
end

end
