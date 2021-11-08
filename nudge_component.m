function [rv0_all, tf_all, PHI_T_all] = nudge_component(rv0, choice, nudge, iter, view_type)
%choice is 1,2,3 representing x,y,z
%nudge is the increment in that direction in km
global mu BODY JUPITER EUROPA SUN LN RL PRIM SEC AU RUNIT TUNIT VUNIT AUNIT


if nargin < 5;  view_type = 2;  end
if nargin < 4;  iter = 20;      end

nudge = nudge/RUNIT;

plot_prims()
mylegend = ["Sec", "Prim"];

for j = 1:iter
    
    % Differential Corrector
    [rv0, ttf] = differential_corrector(rv0, choice);
    
    rv0_all(:,j) = rv0;
    tf_all(j) = ttf*2;
    
    phi0 = reshape(eye(6),36,1);
    y0 = [phi0;rv0];
    
    comp = 2; %This event function should never stop the integration
    val = 1e4;
    DIR = 1;
    comp2 = 1;
    val2 = 1e4;
    lessthan = 1;
    evfcn = @(t,X) compval2(t,X,comp,val,DIR, comp2, val2, lessthan);
    
    etol = 1e-10;
    
    [tt,xx] = ode78ej(@(t,y) CR3BP_STM(t,y,mu),0,tf_all(j),y0,1e-12,0,evfcn,etol);
    
    rv = xx(:,37:42);
    
    PHI_T_all(:,:,j) = reshape(xx(end,1:36),6,6);
   
    
    plt(rv,4);
    view(view_type);
    axis equal

    
    if j < iter
        %Get ready for next step
        rv0(choice) = rv0(choice) + nudge;
    end
end
end

% Needs work on the direction of the differential corrector. I'm trying to
% get a lyapunov orbit to nudge, but the differential corrector stops at
% the wrong x axis crossing

