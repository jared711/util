function [XOrbit, tOrbit, X0, T, C, Monodromy, flag] = CR3BPCorrC(...
    n,X0,Tguess,Cdes,FRAC,INT,DIR,RelTol,AbsTol,DxTol,DzTol,DCTol)
% [XOrbit, tOrbit, X0, T, C, Monodromy, flag] = CR3BPCorrC(...
%     n,X0,Tguess,Cdes,FRAC,INT,DIR,RelTol,AbsTol,DxTol,DzTol,DCTol)
% 
% Single shooting differential corrector for determining symmetric periodic
% orbits in the 3D Circular Restricted 3 Body Problem (CR3BP).

% inputs [dimensions] {defaults}:
% n         :Lagrange point to plot (for reference only) [scalar]
% X0        :initial guess of initial state [6x1]
% Tguess    :initial guess for FULL orbit period [scalar]
% Cdes      :desired Jacobi constant [scalar]
% FRAC      :expected fraction of orbit to correct (1=whole, 2=half) {1}
% INT       :number of intersections to look for before correcting {1}
%            (normally 1, but can be different on e.g. figure eight orbits)
% DIR       :directionality to check for crossing of x-axis:
%            0=any direction, +1=incr., -1=decr. {0}
% RelTol    :integrator relatice tolerance [scalar] {1e-5}
% AbsTol    :integrator absolute tolerance [scalar] or [6x1] {1e-10}
% DxTol     :tolerance for dx/dt at xz-plane crossing [scalar] {1e-13}
% DzTol     :tolerance for dz/dt at xz-plane crossing [scalar] {1e-13}
% DCTol     :tolerance for (C - Cdes) [scalar] {1e-10}
% 
% outputs [dimensions]:
% XOrbit    :converged time dependent state vector [Nx6]
% tOrbit    :corresponding time output [Nx1]
% X0        :converged initial state vector [6x1]
% T         :converged orbit period [scalar]
% C         :orbit Jacobi constant [scalar]
% Monodromy :Monodromy matrix for evaluating orbit stability [6x6]
% flag      :boolean variable indicating convergence
% 
% LOG
% 06/08/2015    Brian D. Anderson
%   Original Code. Modified from "CR3BPCorrFullOrbitE.m"
% 07/08/2015    Brian D. Anderson
%   Modified output messages.
% 07/13/2015    Brian D. Anderson
%   Changed legend to avoid warning when initial guess meets tolerance.
% 08/26/2015    Brian D. Anderson
%   changed linefeed from "\r" to "\r\n" to work on Mac systems.
% 
% Brian D. Anderson
% bdanders@usc.edu
% University of Southern California
% Los Angeles, CA


% set default tolerances if not provided
if nargin < 12
    DCTol   = 1e-13;
end
if nargin < 11
    DzTol   = 1e-13;
end
if nargin < 10
    DxTol   = 1e-13;
end
if nargin < 9
    AbsTol  = 1e-10;
end
if nargin < 8
    RelTol  = 1e-5;
end
if nargin < 7
    DIR     = 0; %default to axis crossing in either direction
end
if nargin < 6
    INT     = 1; %default to first intersection point
end
if nargin < 5
    FRAC    = 1; %default to whole orbit fraction
end

% access globals
global mu

% set xz-plane crossing tolerance
DyTol       = 1e-13;

% solve for lagrange point
Req         = CR3BPLpts;
Req         = Req(:,n);

% set integrator options
optionsE    = odeset('Events',@(t,X) xevent(t,X,DIR),...
    'RelTol',RelTol,'AbsTol',AbsTol);
options     = odeset('RelTol',RelTol,'Abstol',AbsTol);

% initialize iteration count
iter        = 0;

% assemble augmented initial state
Xaug0       = zeros(42,1);
Xaug0(1:6)  = X0;
Xaug0(7:42) = reshape(eye(6,6),36,1);

% set initial guess for partial period
Tfrac       = Tguess/FRAC;

% initialize state and time vectors
t0          = 0;
tf          = 1.5*Tfrac; %extend time slightly to ensure crossing
tFinal      = t0;
XaugFinal   = Xaug0.';

% integrate state and STM until y switches sign INT times
for int = 1:INT
    % integrate to next intersection with y=0
    [t,Xaug,tE,~,~] = ode113(@CR3BPXandSTM,[t0 tf],Xaug0,optionsE);
    
    % concatenate data
    N               = length(t);
    tFinal          = [tFinal; t(2:N)];
    XaugFinal       = [XaugFinal; Xaug(2:N,:)];
    
    % set initial conditions for next segment (ORDER OF OPERATIONS
    % IMPORTANT)
    DT              = 1.5*(tf - t0); % next integration delta-T
    t0              = t(N);          % next integration start time
    tf              = t0 + DT;       % next integration end time
    Xaug0           = Xaug(N,:);
end

% finalize state and time
Xaug        = XaugFinal;
t           = tFinal;
C           = CR3BPJac(X0,true);

% extract fractional period from x-axis crossing
Tfrac       = t(end);

% output warning if event function did not achieve desired dy tolerance
if abs(Xaug(end,2))>DyTol
    warning('xz-plane crossing tolerance not achieved')
end

% determine desired changes
xdotf       = Xaug(end,4);
zdotf       = Xaug(end,6);
dxdotf      = - xdotf;
dzdotf      = - zdotf;
dC          = Cdes - C;
b           = [dxdotf;dzdotf;dC];
bnorm       = norm(b);

% print table header and display current convergence information
fprintf('iteration\t dx/dt\t\t dz/dt\t\t dC\r\n')
fprintf('%d\t\t\t %-+8.1e\t %-+8.1e\t %-+8.1e\r\n', iter, xdotf, zdotf, -dC)

% initialize plot with lagrange point
figure(1)
clf(1)
hold on
plot3(Req(1),Req(2),Req(3),'r+')
plot3(Xaug(:,1),Xaug(:,2),Xaug(:,3),'r-.')
title('ITERATIONS')
hold on
axis equal
xlabel('X (NON)')
ylabel('Y (NON)')
zlabel('Z (NON)')

% initialize best case variables
BestCasebnorm   = bnorm;
BestCasexdotf   = xdotf;
BestCasezdotf   = zdotf;
BestCaseC       = C;
BestCaseX0      = X0;
BestCaseTfrac   = Tfrac;
flag            = true;

% differential corrector loop
while abs(dxdotf) > DxTol || abs(dzdotf) > DzTol || abs(dC) > DCTol
    % update iteration count
    iter        = iter + 1;
    
    % display error and return if iterations exceed a set number
    if iter>25
        flag    = false;
        break
    end
    
    % extract final state, time and STM from previous iteration
    Xf          = Xaug(end,1:6)';
    ydotf       = Xf(5);
%     Tfrac       = t(end)
    STMf        = reshape(Xaug(end,7:42),6,6);
    phiMat      = [ STMf(4,1), STMf(4,3), STMf(4,5);
                    STMf(6,1), STMf(6,3), STMf(6,5)];
    phiVec      = [ STMf(2,1), STMf(2,3), STMf(2,5)];
    
    % compute time derivative of state for final time
    Xdotf       = CR3BPbrian(Tfrac,Xf);
    xzaccf      = [Xdotf(4);Xdotf(6)];
    
    % compute partial derivatives for Jacobi constant
    dCdX        = ComplexStepJac2(@(X) CR3BPJac(X,true),X0);
    dCdx        = dCdX(1);
    dCdz        = dCdX(3);
    dCdydot     = dCdX(5);
    
    % set up system to be solved
    A           = zeros(3,3);
    A(1:2,:)    = phiMat - 1/ydotf*xzaccf*phiVec;
    A(3,:)      = [dCdx, dCdz, dCdydot];
    
    % compute correction to X0
    dxzydot0     = A\b;
    
    % update initial state guess
    X0          = X0 + [dxzydot0(1);0;dxzydot0(2);0;dxzydot0(3);0];
    
    % assemble augmented initial state
    Xaug0       = zeros(42,1);
    Xaug0(1:6)  = X0;
    Xaug0(7:42) = reshape(eye(6,6),36,1);
    
    % initialize state and time vectors
    t0          = 0;
    tf          = 1.5*Tfrac; %extend time slightly to ensure crossing
    tFinal      = t0;
    XaugFinal   = Xaug0.';
    
    % integrate state and STM until y switches sign INT times
    for int = 1:INT
        % integrate to next intersection with y=0
        [t,Xaug]        = ode113(@CR3BPXandSTM,[t0 tf],Xaug0,optionsE);
        
        % concatenate data
        N = length(t);
        tFinal = [tFinal; t(2:N)];
        XaugFinal = [XaugFinal; Xaug(2:N,:)];
        
        % set initial conditions for next segment (ORDER OF OPERATIONS
        % IMPORTANT)
        DT              = 1.5*(tf - t0); % next integration delta-T
        t0              = t(N);          % next integration start time
        tf              = t0 + DT;       % next integration end time
        Xaug0           = Xaug(N,:);
    end
    
    % finalize state and time
    Xaug        = XaugFinal;
    t           = tFinal;
    C           = CR3BPJac(X0,true);

    % determine desired changes
    xdotf       = Xaug(end,4);
    zdotf       = Xaug(end,6);
    dxdotf      = - xdotf;
    dzdotf      = - zdotf;
    dC          = Cdes - C;
    b           = [dxdotf;dzdotf;dC];
    bnorm       = norm(b);
    
    % assign final time conditions
    Tfrac       = t(end);

    % output warning if event function did not achieve desired dy tolerance
    if abs(Xaug(end,2)) > DyTol
        warning('xz-plane crossing tolerance not achieved')
    end
	
    % update best case variables
    if abs(bnorm) < abs(BestCasebnorm)
        BestCasebnorm       = bnorm;
        BestCasexdotf       = xdotf;
        BestCasezdotf       = zdotf;
        BestCaseC           = C;
        BestCaseX0          = X0;
        BestCaseTfrac       = Tfrac;
    end
    
    % display current convergence information
    fprintf('%d\t\t\t %-+8.1e\t %-+8.1e\t %-+8.1e\r\n', iter, xdotf, zdotf, -dC)
    
    % plot iteration trajectory
    plot3(Xaug(:,1), Xaug(:,2), Xaug(:,3))
    drawnow
end

% assign best case outputs
X0          = BestCaseX0;
T           = FRAC*BestCaseTfrac;
C           = BestCaseC;

% display convergence info
if flag
    fprintf(['\r\ntolerance |dx/dt|<%g, |dz/dt|<%g, |dC|<%g ',...
        'achieved after %d iterations\r\n'], DxTol, DzTol, DCTol, iter)
    fprintf('Converged case:\r\n')
    fprintf('dx/dt(T/%d)\t dz/dt(T/%d)\t dC\r\n', FRAC, FRAC)
    fprintf('%-+9.1e\t %-+9.1e\t %-+9.1e\r\n\r\n',...
        BestCasexdotf, BestCasezdotf, BestCaseC - Cdes)
else
    warning(['\r\ntolerance |dx/dt|<%g, |dz/dt|<%g, |dC|<%g not ',...
        'achieved after %d iterations\r\n'], DxTol, DzTol, DCTol, (iter - 1))
    fprintf('Best case:\r\n')
    fprintf('dx/dt(T/%d)\t dz/dt(T/%d)\t dC\r\n', FRAC, FRAC)
    fprintf('%-+9.1e\t %-+9.1e\t %-+9.1e\r\n\r\n',...
        BestCasexdotf, BestCasezdotf, BestCaseC - Cdes)
end

% add plot legend
if iter > 1
    legend(['L_',num2str(n)],'Initial guess','Trajectory iterations')
else
    legend(['L_',num2str(n)],'Initial guess') %if initial guess meets tol
end

% assemble augmented initial state
Xaug0       = zeros(42,1);
Xaug0(1:6)  = X0;
Xaug0(7:42) = reshape(eye(6,6),36,1);

% integrate converged initial state for one full period
[tOrbit,Xaug]    = ode113(@CR3BPXandSTM,[0 T],Xaug0,options);

% extract Monodromy Matrix and state from augmented state
XOrbit      = Xaug(:,1:6);
Monodromy   = reshape(Xaug(end,7:42),6,6);

% determine nearest significant point
dr0prim     = norm(X0(1:3) - [  - mu; 0; 0]);
dr0sec      = norm(X0(1:3) - [1 - mu; 0; 0]);
dr0lpt      = norm(X0(1:3) - Req           );
[mm,ll]     = min([dr0prim,dr0sec,dr0lpt]);

%plot converged trajectory
figure(2)
clf(2)
hold on
if ll == 3
    plot3(Req(1), Req(2), Req(3), 'r+')
    leg = ['L_',num2str(n)];
elseif ll == 2
    plot3(1 - mu, 0, 0, 'ko')
    leg = 'Secondary';
elseif ll == 1
    plot3(  - mu, 0, 0, 'ko')
    leg = 'Primary';
end
plot3(XOrbit(:,1),XOrbit(:,2),XOrbit(:,3),'m-')
axis equal
Title3 = ['Final orbit, ',num2str(iter),' iterations, ',...
    '|\deltaxdot(T/',num2str(FRAC),')|=',num2str(abs(BestCasexdotf),'%.1e'),...
    ', |\deltazdot(T/',num2str(FRAC),')|=',num2str(abs(BestCasezdotf),'%.1e'),...
    ', |\deltaC|=',num2str(abs(BestCaseC - Cdes),'%.1e')];
title(Title3)
xlabel('X (NON)')
ylabel('Y (NON)')
zlabel('Z (NON)')
legend(leg, 'Orbit')
view(3)

end

function [value,isterminal,direction] = xevent(t,X,DIR)
% Locate the time when y component of state passes through zero and stop
% integration.

value       = X(2);     % detect y = 0
isterminal  = 1;        % stop the integration
direction   = DIR;      % 0=any direction, +1=incr., -1=decr.

end


% DETAILED DESCRIPTION
% 
% Attempts to generate a periodic orbit in the Circular Restricted 3 Body
% Problem (CR3BP). The equations of motion and output are all defined in
% the rotating frame and in non-dimensional units. The single shooting
% method propagates the initial state forward to the xz-plane intersection.
% Then, the corrector seeks to eliminate the velocity in the xz-plane as
% well as match the Jacobi constant to a desired value. The parameters
% varied to achieve this are the initial components x, z and dy/dt. 
% 
% This function was designed to be versatile, in order to correct many
% different types of orbits. The three variables FRAC, INT and DIR allow
% the user to determine which type of orbit to look for. FRAC represents
% the fraction of the orbit you expect to be correcting, this is usually 1
% or 2 for either full or half orbit, respectively. This variable simply
% adjusts the final converged time to reflect a full orbit period. INT
% determines how many intersections with the xz-plane to look for before
% stopping the propagation and correcting the initial state. For simple
% orbits this is usually 1 or 2, where the first or second intersection
% with the xz-plane is perpendicular (as with a halo orbit). For more
% complex orbits, that cross the axis multiple times at non-perpendicular
% angles before completing a period, this number can be larger (such as for
% vertical Lyapunov orbits). DIR is the direction of intersection to
% detect. This is usually 0 for all types, but can be set to strictly
% detect increasing or decreasing if previous knowledge of the orbit
% properties are known. 
% USES EVENT FUNCTION TO DETERMINE CROSSING