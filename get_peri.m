function [r_peri, k, peri_idx] = get_peri(xx, body, mu)
%GET_PERI Compute periapsis of a trajctory with respect to a given body
% 
% [r_peri, k, peri_idx] = GET_PERI(xx, body)
% 
% Inputs:   xx (Nx6) [NON] trajectory
%           body (string) name of body {'SEC'}
%           mu (scalar) [] mass parameter
% 
% Outputs:  r_peri (kx1) [NON] Periapsis distance
%           k (int) [] number of periapses found
%           peri_idx (kx1) indices of periapses
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/11/23 17:12:37 	Revision: 0.1 $
% Author: Jared Blanchard 	Date: 2023/06/13 17:30:31 	Revision: 0.2 added mu as input and peri_idx as output$


if nargin < 3;  global mu;      end
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
peri_idx = find(peri_idx); %output the indices rather than a vector of zeros and ones


end