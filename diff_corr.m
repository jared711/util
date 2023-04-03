function [rv0, ttf, cond_num] = diff_corr(rv0, const, iter, plot, t0, tf, dir, tol)
% function [rv0, ttf, cond_num] = diff_corr(rv0, const, iter, plot, t0, tf, dir, tol)
% Updated version of differential corrector, more flexible 8/26/2022
% Inputs:
%           rv0 (6x1) [NON]     initial state [r0; v0]
%           const (integer) []  parameter held constant (1,3,5 for x,z,ydot)
%           iter (integer) []   max number of iterations {100}
%   plot    - single boolean,   1 plots iterations {0}
%   t0      - scalar double,    initial time for integration {0}
%   tf      - scalar double,    final time for integration {100}
%   dir     - single boolean,   true if approaching x axis from -y,
%                               false if approaching x axis from +y {1}
%   tol     - single double,    tolerance for differential corrector {1e-10}

%Requires global mu
global mu

if nargin < 8;  tol = 1e-10;    end
if nargin < 7;  dir = 1;        end
if nargin < 6;  tf = 100;       end
if nargin < 5;  t0 = 0;         end
if nargin < 4;  plot = 0;       end
if nargin < 3;  iter = 100;     end
if nargin < 2;  const = 1;      end
if const == 3 && rv0(cons) == 0
    warning("If you are holding z constant for a planar orbit, beware. You will get a singular matrix");
end

if ~iscolumn(rv0); rv0 = rv0';     end
if ~iscolumn(rv0) %if it's still not a column vector
    error('input must be single state vector, not array');    
end

comp = 2;
val = 0;
DIR = dir;
comp2 = 1;
val2 = 1e4;
lessthan = 1;
% evfcn = @(t,X) compval2(t,X,comp,val,DIR, comp2, val2, lessthan);
evfcn = @(t,x) ef_XZplane_reverse(t,x,DIR);

etol = 1e-10;

phi0 = reshape(eye(6),36,1);

for k = 1:iter
    y0 = [phi0;rv0];            %Initial state
    
    [tt,xx] = ode78ej(@(t,y) CR3BP_STM(t,y,mu),t0,tf,y0,1e-12,0,evfcn,etol);
    
    rv = xx(:,37:42);           %all integrated states
    phi = xx(:,1:36);           %all integrated flattened STMs
    ttf = tt(end);
    
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
    
    cond_num(k) = cond(PHI_T2) %print condition number for comparison
    
    if abs([delxdot; delzdot]) < tol
        break
    end
    
    ydot = rvT2(5);
    
    if const == 1
        
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
    else
        ME = MException('Check choice:', ...
             'Only x, z, or ydot can be held constant');
          throw(ME);
    end
    clear tt xx rv phi
end
end

%Changelog
%Date           Programmer              Action
%07/18/2019     Jared T. Blanchard      File Created based on scripts made
%                                       by the author