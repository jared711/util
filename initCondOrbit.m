function [rv0, C0, T0, stab_idx0, mu0] = initCondOrbit(C, varargin)
%INITCONDORBIT returns initial condition of orbit from JPL Periodic Orbit
%database
% 
% [rv0, C0, T0, stab_idx0, mu0]] = INITCONDORBIT(C)
% 
% Inputs:   C (scalar) [NON] Jacobi constant 
% 
% Outputs:  rv0 (6x1) [NON] initial conditions of periodic orbit
%           C0 (scalar) [NON] Jacobi constant of periodic orbit
%           T0 (scalar) [NON] Period of periodic orbit
%           mu0 (scalar) [NON] mass parameter used to compute periodic orbit
% 
% See also: 

% Author: Jared Blanchard 	Date: 2023/10/13 14:53:08 	Revision: 0.1 $

p = inputParser;
addOptional(p,'system', "europa", @isstring)
addOptional(p,'type', "Halo", @isstring)
addOptional(p,'Lpt', "L2", @isstring)
parse(p,varargin{:});
system = p.Results.system;
type = p.Results.type;
Lpt = p.Results.Lpt;

filename = sprintf("~/UBUNTU/util/data/%s%s%s.csv",system,type,Lpt);
orbit = readmatrix(filename);
Cs = orbit(:,8);
assert(C < max(Cs) && C > min(Cs),'C not within range') % make sure C is in the range of the orbits in the database
[~,idx] = min(abs(Cs - C)); % find the index of the orbit with the Jacobi constant closest to C
rv0 = orbit(idx,2:7);
C0 = orbit(idx,8);
T0 = orbit(idx,9);
stab_idx0 = orbit(idx,11);
mu0 = orbit(idx,12);

end
