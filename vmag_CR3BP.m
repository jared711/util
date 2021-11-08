function [v_mag] = vmag_CR3BP(r, C, mu)
%VMAG_CR3BP Computes the required velocity magnitude of the state with
%position components r and Jacobi constant C in the normalized CR3BP
% 
% [v_mag] = VMAG_CR3BP(r,C)
% 
% Inputs: 
%           r (3xN) [] position vector in normalized CR3BP
%           C (Nx1) [] Jacobi constant in normalized CR3BP
% 
% Outputs: 
%          v_mag (Nx1) [] velocity magnitude
% 
% See also: 

% Author: Jared Blanchard 	Date: 2021/10/25 14:14:01 	Revision: 0.1 $

% make sure r is of appropriate dimensions
if nargin < 3;  global mu;  end
if isempty(mu); warning('no global mu declared');   end

[m,n] = size(r);
if m ~= 3
    if n == 3
        r = r';
    else
        error('r should be 3xN')
    end
else
    if n == 3
        warning('dimensions ambiguous; r should be 3xN')
    end
end
        

r1 = r - [-mu; 0; 0];
r2 = r - [1-mu; 0; 0];
v_mag = sqrt(r(1,:).^2 + r(2,:).^2 + 2*(1-mu)./vecnorm(r1) + 2*mu./vecnorm(r2) - C);

end
