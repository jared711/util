function F_theta = jac_theta(dDinvdtheta, D, F_vec)
%JAC_THETA Jacobian of stroboscopic map with respect to theta
% 
% [F_theta] = JAC_THETA(dDinvdtheta, D, F_vec)
% 
% Inputs:    
% 
% Outputs:  
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/11/10 16:27:09 	Revision: 0.1 $

% c = Du
% c_F = D*F(u)
% F(u) = Dinv*c_F
% d(F(u))/dtheta = d(Dinv)/dtheta * c_F
%  = d(Dinv)/dtheta*D*F(u)

F_theta = real(dDinvdtheta*D*F_vec);

end
