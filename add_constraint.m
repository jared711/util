function [M, uG_error] = add_constraint(M, uG_error, constraint_idx, constraint_error)
%ADD_CONSTRAINT Add a constraint row to the matrix M for the Newton Step
% 
% [M, uG_error] = ADD_CONSTRAINT(M, uG_error, constraint_idx, constraint_error)
% 
% Inputs:   M (~xm) [] matrix for Newton Step 
% 
% Outputs:  M (type) [] updated matrix for Newton Step 
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/11/10 16:33:21 	Revision: 0.1 $

[~,m] = size(M);

if nargin < 4;  constraint_error = 0;   end
if length(constraint_idx) == 1
    % add a row of zeros with a sigle 1 to M
    constraint = zeros(1,m);
    constraint(constraint_idx) = 1; 
end

M = [M;constraint];

uG_error = [uG_error;constraint_error]; % append a zero, or other constraint to the bottom of uG_error

if height(M) ~= height(uG_error)   
    error("M and uG_error should have same number of rows");
end

end
