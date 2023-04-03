function [idx_s, idx_u] = find_stable_eigs(lambda)
%FIND_STABLE_EIGS for use with invariant_manifolds for finding the indices
%of the stable/unstable eigenvalues of the STM
% 
% [idx_s, idx_u] = FIND_STABLE_EIGS(lambda)
% 
% Inputs:   lambda [] (6x1) eigenvalues of STM 
% 
% Outputs:  idx_s [] (integer) index of stable eigenvalue
%           idx_u [] (integer) index of unstable eigenvalue
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/01/31 10:47:43 	Revision: 0.1 $

% dist1 = abs(lambda-1);
% [~, idx_1] = mink(dist1, 2);

dist1 = abs(abs(lambda) - 1); % find the eigenvalues with magnitude closest to one
[~, idx_1] = mink(dist1, 2);

idx_2 = find(lambda < 0);
if isempty(idx_2)
    [~,idx_2] = maxk(abs(imag(lambda)),2);
    keyboard % idx_2 should be the two complex eigenvalues
end

idx_su = setdiff(1:6, unique([idx_1;idx_2]));



if abs(lambda(idx_su(1))) > 1 % if the eigenvalue is larger than 1, it is unstable
    idx_u = idx_su(1);
    idx_s = idx_su(2);
else
    idx_u = idx_su(2);
    idx_s = idx_su(1);
end

if abs(lambda(idx_u)*lambda(idx_s) - 1) > 1e-6
    warning('stable and unstable eigenvalues may not be inverses')
end

end
