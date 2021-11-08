%SETENCELADUSHILL script to set up global variables with parameters
% describing various Hill Systems
% 
% See also: 

% Author: Jared Blanchard 	Date: 2021/09/28 12:17:23 	Revision: 0.1 $
% Data pulled from B. F. Villac and D. J. Scheeres, “Escaping trajectories in the Hill three-body problem and applications,” J. Guid. Control. Dyn., vol. 26, no. 2, pp. 224–232, 2003, doi: 10.2514/2.5062.

global MOON_H EUROPA_H ENCELADUS_H J_L2 x_L2

MOON_H.mu = 4.903e3; %[km^3/s^2] This number feels weird to me
MOON_H.N = 2.662e-6; %[rad/s]
MOON_H.l = 88454.7; %[km]
MOON_H.tau = 1/3600/MOON_H.N; %[hr]
MOON_H.R = 1738; %[km]

EUROPA_H.mu = 3.193e3; %[km^3/s^2] This number feels weird to me
EUROPA_H.N = 2.048e-5; %[rad/s]
EUROPA_H.l = 19672.6; %[km]
EUROPA_H.tau = 1/3600/EUROPA_H.N; %[hr]
EUROPA_H.R = 1569; %[km]

ENCELADUS_H.mu = 4.931; %[km^3/s^2] This number feels weird to me
ENCELADUS_H.N = 5.307e-5; %[rad/s]
ENCELADUS_H.l = 1205.2; %[km]
ENCELADUS_H.tau = 1/3600/ENCELADUS_H.N; %[hr]
ENCELADUS_H.R = 250; %[km]

J_L2 = -0.5*9^(2/3); % analytical Jacobi Constant analog of L2 point
x_L2 = (1/3)^(1/3); % analytical location of L2 in Hill's Problem
