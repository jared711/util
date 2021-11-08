function XandSTMdot = CR3BPXandSTM(t,XandSTM)
% XandSTMdot = CR3BPXandSTM(t,XandSTM)
% 
% Circular Restricted 3 Body Problem (CR3BP) State Transition Matrix (STM) 
% and state vector combined system of equations. The Origin may be 
% relocated to any of the Lagrange points 
% 
% inputs:
% t             :time
% XandSTM       :combined state vector relative to Lagrange point and State
%                Transition Matrix [42x1]
% mu            :system mass ratio
% RL            :position vector of Lagrange point, relative to primary
%                barycenter
% 
% outputs:
% XandSTMdot    :time derivative of combined input vector [42x1]
% 
% variables:
% X             :system state vector X(t) = [x y z xdot ydot zdot]' [6x1]
% STM           :system State Transition Matrix, PHI(t) [6x6]
% Xdot          :system state vector time derivative
% STMdot        :system State Transition Matrix time derivative
% J             :system Jacobian Matrix, J(X(t)) (4x4)
% d2            :d=distance to larger primary, d2 = d^2
% d3            :d^3
% d5            :d^5
% r2            :r=distance to smaller primary, r2 = r^2
% r3            :r^3
% r5            :r^5
% 
% Record of Revision
% Date          Programmer          Description of Changes
% 08/20/2012    Brian D. Anderson   Original Code
% 12/09/2012    Brian D. Anderson   Improved computation efficiency


% access global variables
global mu RL

% extract state vector and STM
X           = XandSTM(1:6);
STM         = reshape(XandSTM(7:42),6,6);

% correct for possible origin relocation
if ~isempty(RL)
    X(1:3)  = X(1:3) + RL;
end

% set non variant 3x3 submatrices of Jacobian
J           = zeros(6,6);
J(1:3,4:6)  = eye(3,3);
J(4:6,4:6)  = [0 2 0;-2 0 0;0 0 0];

% calculate numerators for use in variant submatrix of Jacobian
mu1         = 1 - mu;
xx1         = X(1) + mu; %x component for r1
xx2         = X(1) - mu1; %x component for r2
r12         = xx1^2 + X(2)^2 + X(3)^2; %r1^2
r22         = xx2^2 + X(2)^2 + X(3)^2; %r2^2
r13         = r12^1.5; %r1^3
r23         = r22^1.5; %r2^3
r15         = r12^2.5; %r1^5
r25         = r22^2.5; %r2^5

% calculate variant 3x3 submatrix of Jacobian
J(4,1)      = 1 - mu1*(1/r13 - 3*xx1^2/r15) - mu*(1/r23 - 3*xx2^2/r25);
J(4,2)      = 3*mu1*xx1*X(2)/r15 + 3*mu*xx2*X(2)/r25;
J(4,3)      = 3*mu1*xx1*X(3)/r15 + 3*mu*xx2*X(3)/r25;
J(5,1)      = J(4,2);
J(5,2)      = 1 - mu1*(1/r13 - 3*X(2)^2/r15) - mu*(1/r23 - 3*X(2)^2/r25);
J(5,3)      = 3*mu1*X(2)*X(3)/r15 + 3*mu*X(2)*X(3)/r25;
J(6,1)      = J(4,3);
J(6,2)      = J(5,3);
J(6,3)      = - mu1*(1/r13 - 3*X(3)^2/r15) - mu*(1/r23 - 3*X(3)^2/r25);

% STM matrix differential equation
STMdot      = J*STM;

% State vector differential equations
Xdot        = zeros(6,1);
Xdot(1)     = X(4);
Xdot(2)     = X(5);
Xdot(3)     = X(6);
Xdot(4)     = 2*X(5) + X(1) - mu1*xx1/r13 - mu*xx2/r23;
Xdot(5)     = - 2*X(4) + X(2) - mu1*X(2)/r13 - mu*X(2)/r23;
Xdot(6)     = - mu1*X(3)/r13 - mu*X(3)/r23;

% Reassemble combined output vector 
XandSTMdot          = zeros(42,1);
XandSTMdot(1:6)     = Xdot;
XandSTMdot(7:42)    = reshape(STMdot,36,1);