function Xdot = CR3BP(t,X)
% Xdot = CR3BP(t,X)
% 
% Equations of motion for the three dimensional Circular Restricted 3 Body 
% Problem (CR3BP), broken down into a system of first order differential 
% equations.
% 
% inputs:
% t             :non-dimensional time
% X             :system state vector, X(t) = [x y z xdot ydot zdot]' 
%                [6x1]/[1x6]
% mu            :primary mass ratio
% RL            :position vector of lagrange point set as origin for input
%                [3x1]
% 
% outputs:
% Xdot         :system state vector time derivative
% 
% Record of Revision
% Date          Programmer          Description of Changes
% 08/26/2011    Brian D. Anderson   Original Code
% 08/13/2012    Brian D. Anderson   Added option for origin relocation
% 02/19/2013    Brian D. Anderson   Modified transpose to accomodate
%                                   complex step derivative
% 07/19/2013    Brian D. Anderson   initialized xdot as column instead of
%                                   transposing after creation


% access global variables
global mu RL

% correct for possible origin relocation
if ~isempty(RL)
    X(1:3) = X(1:3) + RL;
end

% calculate cube of distances to both primaries
mu1     = 1 - mu;
xx1     = X(1) + mu; %x component for r
xx2     = X(1) - mu1; %x component for d
d3      = (xx1^2 + X(2)^2 + X(3)^2)^1.5; %r^3
r3      = (xx2^2 + X(2)^2 + X(3)^2)^1.5; % %d^3

% assign time derivative state vector elements
Xdot    = zeros(6,1);
Xdot(1) = X(4);
Xdot(2) = X(5);
Xdot(3) = X(6);
Xdot(4) = 2*X(5) + X(1) - mu1*xx1/d3 - mu*xx2/r3;
Xdot(5) = - 2*X(4) + X(2) - mu1*X(2)/d3 - mu*X(2)/r3;
Xdot(6) = - mu1*X(3)/d3 - mu*X(3)/r3; 