function [r_peri, k] = get_peri(xx, body)
%GET_PERI Compute periapsis of a trajctory with respect to a given body
% 
% [r_peri, k] = GET_PERI(xx, body)
% 
% Inputs:   xx (Nx6) [NON] trajectory
%           body (string) name of body {'SEC'}
% 
% Outputs:  r_peri (kx1) [NON] Periapsis distance
%           k (int) [] number of periapses found
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/11/23 17:12:37 	Revision: 0.1 $
global mu
if nargin < 2;  body = "SEC";   end

switch body
    case "SEC"
        c = [1-mu;0;0];
    case "PRIM"
        c = [-mu;0;0];
    otherwise
        c = [0;0;0];
end

r = vecnorm(xx(:,1:3)' - c);
peri_idx = islocalmin(r);
r_peri = r(peri_idx);
if isempty(r_peri)
    warning("No Periapsis Found")
    r_peri = r(1);
end
k = sum(peri_idx);

end