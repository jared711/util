function dFdz = ComplexStepJac2(Func,z)
% dFdz = ComplexStepJac2(Func,z,FuncSize)
% 
% Complex step derivative approximation to the Jacobian dF/dz of any vector
% valued function F(z,params). Do not use this with any matrix valued
% function!
% 
% inputs:
% Func      :function handle for F(z,params), make sure to use a format
%            that makes the handle only a function of z within this
%            function. e.g. "@(z) FuncName(z,params)" output is [px1]
% z         :variable for partial [qx1]
% 
% outputs:
% dFdz      :approximate Jacobian [pxq]
% 
% Record of Revision
% Date          Programmer          Description of Changes
% 02/23/2013    Brian D. Anderson   Original Code. Based on
%                                   "ComplexStepJac.m"
% 
% Brian D. Anderson
% bdanders@usc.edu
% University of Southern California
% Los Angeles, CA


% set complex step length
h       = 1e-100;

% determine variable size
q       = length(z);

% initialize vector perturbation matrix
Q       = 1i * h * eye(q, q);

% compute 1st column of perturbed function array and determine system size
Fc1     = feval(Func, z + Q(:,1));
p       = length(Fc1);

% initialize perturbed function array
Fc      = zeros(p,q);
Fc(:,1) = Fc1;

% compute remaining columns of perturbed function array
if q > 1
    for col = 2:q
        Fc(:,col)   = feval(Func, z + Q(:,col));
    end
end

% solve for first derivative approximations
dFdz    = imag(Fc) / h;