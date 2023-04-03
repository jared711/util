function [rv0, ttf, cond_num] = differential_corrector(rv0, const, iter, plot, t0, tf, dir, tol,comp2,val2,lessthan)
% function [rv0, ttf, cond_num] = differential_corrector(rv0, const, iter, plot, t0, tf, dir, tol)
% Inputs:
%   rv0     - 6x1 double array, initial state [r0; v0]
%   const   - scalar integer,   parameter held constant (1,3,5 for x,z,ydot, 13 for x and z)
%   iter    - scalar integer,   max number of iterations {100}
%   plot    - single boolean,   1 plots iterations {0}
%   t0      - scalar double,    initial time for integration {0}
%   tf      - scalar double,    final time for integration {100}
%   dir     - single boolean,   true if approaching x axis from -y,
%                               false if approaching x axis from +y {1}
%   tol     - single double,    tolerance for differential corrector {1e-10}
%   comp2   - scalar integer,   second component for comparison {1 (x)}
%   val2    - scalar double,    value of second component for comparison {0}
%   lessthan- scalar signint    if lessthan == 1 comparison is true if comp2 < val2
%                               if lessthan == -1 comparison is true if comp2 > val2

%Requires global mu
global mu

if nargin < 11; lessthan = 1;   end
if nargin < 10; val2 = 0;       end
if nargin < 9;  comp2 = 1;      end
if nargin < 8;  tol = 1e-10;    end
if nargin < 7;  dir = 1;        end
if nargin < 6;  tf = 100;       end
if nargin < 5;  t0 = 0;         end
if nargin < 4;  plot = 0;       end
if nargin < 3;  iter = 100;     end

if ~iscolumn(rv0); rv0 = rv0';     end
if ~iscolumn(rv0) %if it's still not a column vector
    error('input must be single state vector, not array');    
end

comp = 2;
val = 0;
DIR = dir;
evfcn = @(t,X) compval2(t,X,comp,val,DIR, comp2, val2, lessthan);

etol = 1e-10;

phi0 = reshape(eye(6),36,1);

for k = 1:iter
    s0 = [phi0;rv0];            %Initial state
    
    [tt,xx] = ode78ej(@(t,y) CR3BP_STM(t,y,mu),t0,tf,s0,1e-12,0,evfcn,etol);
    
    rv = xx(:,37:42);           %all integrated states
    phi = xx(:,1:36);           %all integrated flattened STMs
    ttf = tt(end);

    fprintf("k = %i, C = %0.6f \n",k,jacobi_constant(rv0))

    if plot == 1
        figure()
        plot_rv(rv);
        title(['Iteration ', num2str(k)])
        grid on
    end
    
    %Reshape final STM into 6x6 matrices
    PHI_T2 = reshape(phi(end,:),6,6);
    rvT2 = rv(end,:);
    delxdot = 0 - rvT2(4); % desired change in xdot and zdot
    delzdot = 0 - rvT2(6);
    
    cond_num(k) = cond(PHI_T2); %print condition number for comparison
    
    if abs([delxdot; delzdot]) < tol
        break
    end

    ydot = rvT2(5);

    if iscell(const)
        C_star = const{2};
        C0 = jacobi_constant(rv0);
%         x0 = rv0(1);
%         z0 = rv0(3);
        
        ydot0 = rv0(5);
        rvdot0 = CR3BP(0,rv0);
        xddot0 = rvdot0(4);
        zddot0 = rvdot0(6);
        
%         r13 = norm(rv0(1:3) - [-mu;0;0])^3;
%         r23 = norm(rv0(1:3) - [1-mu;0;0])^3;
%         Omega_x0 = -((1-mu)*(x0 + mu)/r13 + mu*(x0 - 1 + mu)/r23) + x0;
        Omega_x0 = xddot0 - 2*ydot0;
%         Omega_z0 = -((1-mu)*z0       /r13 + mu*z0           /r23)             ; 
        Omega_z0 = zddot0;

        PHI_partial = [PHI_T2(4,1), PHI_T2(4,3), PHI_T2(4,5);
                       PHI_T2(6,1), PHI_T2(6,3), PHI_T2(6,5);
                       -2*Omega_x0, -2*Omega_z0,  -2*ydot];
        
        state_dot = CR3BP_STM(0, [phi(end,:)'; rv(end,:)'], mu);
        xdoubledot = state_dot(40);
        zdoubledot = state_dot(42);
        dyad = [xdoubledot;zdoubledot;0]*[PHI_T2(2,1), PHI_T2(2,3), PHI_T2(2,5)];
        
        delxz_ydot = (PHI_partial-(1/ydot)*dyad)\[delxdot;delzdot;C_star - C0];
        delx = delxz_ydot(1);
        delz = delxz_ydot(2);
        delydot = delxz_ydot(3);
        
        rv0 = rv0 + [delx;
            0;
            delz;
            0;
            delydot;
            0];
    elseif const == 0
        
        PHI_partial = [PHI_T2(4,1),PHI_T2(4,3),PHI_T2(4,5);
           PHI_T2(6,1),PHI_T2(6,3),PHI_T2(6,5)];
        
        state_dot = CR3BP_STM(0, [phi(end,:)'; rv(end,:)'], mu);
        xdoubledot = state_dot(40);
        zdoubledot = state_dot(42);
        dyad = [xdoubledot;zdoubledot]*[PHI_T2(2,1), PHI_T2(2,3), PHI_T2(2,5)];
        
        delxz_ydot = (PHI_partial-(1/ydot)*dyad)\[delxdot;delzdot];
        delx = delxz_ydot(1);
        delz = delxz_ydot(2);
        delydot = delxz_ydot(3);
        
        rv0 = rv0 + [delx;
            0;
            delz;
            0;
            delydot;
            0];
    elseif const == 1
        
        PHI_partial = [PHI_T2(4,3),PHI_T2(4,5);
            PHI_T2(6,3),PHI_T2(6,5)];
        
        state_dot = CR3BP_STM(0, [phi(end,:)'; rv(end,:)'], mu);
        xdoubledot = state_dot(40);
        zdoubledot = state_dot(42);
        dyad = [xdoubledot;zdoubledot]*[PHI_T2(2,3), PHI_T2(2,5)];
        
        delz_ydot = (PHI_partial-(1/ydot)*dyad)\[delxdot;delzdot];
        delz = delz_ydot(1);
        delydot = delz_ydot(2);
        
        rv0 = rv0 + [0;
            0;
            delz;
            0;
            delydot;
            0];
    elseif const == 3
        PHI_partial = [PHI_T2(4,1),PHI_T2(4,5);
            PHI_T2(6,1),PHI_T2(6,5)];
        
        state_dot = CR3BP_STM(0, [phi(end,:)'; rv(end,:)'], mu);
        xdoubledot = state_dot(40); % compute the accelerations at the final state
        zdoubledot = state_dot(42);
        dyad = [xdoubledot;zdoubledot]*[PHI_T2(2,1), PHI_T2(2,5)];
        
        delx_ydot = (PHI_partial-(1/ydot)*dyad)\[delxdot;delzdot];
        delx = delx_ydot(1);
        delydot = delx_ydot(2);
        
        rv0 = rv0 + [delx;
            0;
            0;
            0;
            delydot;
            0];
    elseif const == 5
        PHI_partial = [PHI_T2(4,1),PHI_T2(4,3);
            PHI_T2(6,1),PHI_T2(6,3)];
        
        state_dot = CR3BP_STM(0, [phi(end,:)'; rv(end,:)'], mu);
        xdoubledot = state_dot(40);
        zdoubledot = state_dot(42);
        dyad = [xdoubledot;zdoubledot]*[PHI_T2(2,1), PHI_T2(2,3)];
        
        delx_z = (PHI_partial-(1/ydot)*dyad)\[delxdot;delzdot];
        delx = delx_z(1);
        delz = delx_z(2);
        
        rv0 = rv0 + [delx;
            0;
            delz;
            0;
            0;
            0];
    elseif const == 13
        PHI_partial = [PHI_T2(4,5);
                       PHI_T2(6,5)];
        
        state_dot = CR3BP_STM(0, [phi(end,:)'; rv(end,:)'], mu);
        xdoubledot = state_dot(40); % compute the accelerations at the final state
        zdoubledot = state_dot(42);
        dyad = [xdoubledot;zdoubledot]*PHI_T2(2,5);
        
        delydot = (PHI_partial-(1/ydot)*dyad)\[delxdot;delzdot];
%         delx = delx_ydot(1);
%         delydot = delx_ydot(2);
        
        rv0 = rv0 + [0;
            0;
            0;
            0;
            delydot;
            0];
    else

        ME = MException('Check choice:', ...
             'Only x, z, or ydot can be held constant');
          throw(ME);
    end
    clear tt xx rv phi
end
fprintf("Differential Corrector converged in %i/%i iterations\n",k,iter)
end

%Changelog
%Date           Programmer              Action
%07/18/2019     Jared T. Blanchard      File Created based on scripts made
%                                       by the author