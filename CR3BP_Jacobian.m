function [A] = CR3BP_Jacobian(rv, mu)
%CR3BP_JACOBIAN Jacobian of CR3BP nonlinear equations of motion
% 
% [A] = CR3BP_JACOBIAN(rv, mu))
% 
% Inputs:   rv (6x1) [NON] state
%           mu (scalar) [] mass parameter
% 
% Outputs:  A (6x6) [] Jacobian matrix
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/12/02 15:53:03 	Revision: 0.1 $

if nargin < 2; global mu; end

x = rv(1);
y = rv(2);
z = rv(3);

mu2 = 1-mu;

r2= (x+mu )^2 + y^2 + z^2;	% r: distance to m1, LARGER MASS
R2= (x-mu2)^2 + y^2 + z^2;	% R: distance to m2, smaller mass
r3= r2^1.5; r5= r2^2.5;
R3= R2^1.5; R5= R2^2.5;

omgxx= 1+(mu2/r5)*(3*(x+mu)^2)+(mu/R5)*(3*(x-mu2)^2)-(mu2/r3+mu/R3);
omgyy= 1+(mu2/r5)*(3* y^2    )+(mu/R5)*(3* y^2     )-(mu2/r3+mu/R3);
omgzz=   (mu2/r5)*(3* z^2    )+(mu/R5)*(3* z^2     )-(mu2/r3+mu/R3);

omgxy= 3*y*  (mu2*(x+mu)/r5+mu*(x-mu2)/R5);
omgxz= 3*z*  (mu2*(x+mu)/r5+mu*(x-mu2)/R5);
omgyz= 3*y*z*(mu2       /r5+mu        /R5);

A  =[   0     0     0     1     0	 0 ;
        0     0     0     0 	1 	 0 ;
        0     0     0     0     0    1 ;
    omgxx omgxy omgxz     0     2 	 0 ;
    omgxy omgyy omgyz    -2     0 	 0 ;
    omgxz omgyz omgzz     0	    0	 0 ];

end
