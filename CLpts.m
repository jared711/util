function [CL1, CL2, CL3, CL4, CL5] = CLpts(mu)
%CLPTS returns the jacobi constants of the 5 Lagrange points for a given mass parameter mu 
% 
% [CL1, CL2, CL3, CL4, CL5] = CLPTS(mu)
% 
% Inputs:   mu [] (scalar) mass parameter
% 
% Outputs:  CL1 [] (scalar) Jacobi constant of L1
% 	    CL2 [] (scalar) Jacobi constant of L2
%	    CL3 [] (scalar) Jacobi constant of L3
%	    CL4 [] (scalar) Jacobi constant of L4
%	    CL5 [] (scalar) Jacobi constant of L5
% See also: 


% Author: Jared Blanchard 	Date: 2022/03/07 16:25:13 	Revision: 0.1 $

if nargin < 1;  global mu;  end

Cs = jacobi_constants([CR3BPLpts; zeros(3,5)]);
CL1 = Cs(1);    CL2 = Cs(2);    CL3 = Cs(3);
CL4 = Cs(4);    CL5 = Cs(5);
end
