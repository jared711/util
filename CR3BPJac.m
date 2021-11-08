function C = CR3BPJac(X,column)
% C = CR3BPJac(X,column)
% 
% This function calculates the Jacobi Constant in the three dimensional
% Circular Restricted 3 Body Problem (CR3BP) for a given state vector and
% primary mass ratio.
% 
% inputs:
% X             :state vector [Nx6]/[6xN]
% column        :true/false variable indicating wether input is row or
%                column vector array
%
% outputs: 
% C             :energy associated with given state vector(Jacobi Constant)
%                [Nx1]/[1xN]
% 
% Record of Revision
% Date          Programmer          Description of Changes
% 04/28/2013    Brian D. Anderson   Original Code
% 04/02/2014    Brian D. Anderson   Added input option to force row vector
% 
% Brian D. Anderson
% bdanders@usc.edu
% University of Southern California
% Los Angeles, CA


% access globals
global mu

% determine row/column if input not given
if nargin<2
    % determine whether input state is column or row vector
    S       = size(X);
    column  = S(1) == 6;
end

% turn column vectors into row vectors
if column
    X = X.';
end

% calculate potential 
U = (1 - mu)./sqrt((X(:,1) + mu).^2 + X(:,2).^2 + X(:,3).^2) + ...
    mu./sqrt((X(:,1) - 1 + mu).^2 + X(:,2).^2 + X(:,3).^2) + ...
    0.5*(X(:,1).^2 + X(:,2).^2);

% calculate energy
C = 2*U - (X(:,4).^2 + X(:,5).^2 + X(:,6).^2);

% turn row vectors back into column vectors
if column
    C = C.';
end