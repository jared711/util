function [Omega] = aug_pot(x,y,z,mu,conv)
%AUG_POT Computes the dimensionless augmented potential in the rotating frame
% 
% [Omega] = AUG_POT(x,y,z,mu,conv)
% 
% Inputs:   x [] (Nx1) vector of dimensionless x values
%           y [] (Nx1) vector of dimensionless y values
%           z [] (Nx1) vector of dimensionless z values
%           mu [] (scalar) dimensionless gravitational parameter
%           conv [] (bool) marker 
% 
% Outputs: 
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/02/09 09:06:28 	Revision: 0.1 $

if nargin < 5;  conv = 1;           end
if nargin < 4;  global mu;          end
if nargin < 3;  z = zeros(size(x)); end

r1 = sqrt((x+mu).^2 + y.^2 + z.^2); % note that these deviate from Szebehely who says x-mu
r2 = sqrt((x-1+mu).^2 + y.^2 + z.^2);

Omega = (x.^2 + y.^2)./2 + (1-mu)./r1 + mu./r2;
if conv
    Omega = Omega + mu*(1-mu)/2;
end

end
