function U = augmented_potential_ER3BP(x,y,z,e,f,mu,conv)
% U = augmented_potential_ER3BP(x,y,z,e,f,mu,conv)

if nargin < 7;  conv = 1;           end
if nargin < 6;  global mu;          end
if nargin < 5;  f = pi/2;           end
if nargin < 4;  e = 0;              end
if nargin < 3;  z = zeros(size(x)); end

r1 = sqrt((x+mu).^2 + y.^2 + z.^2);
r2 = sqrt((x-1+mu).^2 + y.^2 + z.^2);

U = -(x.^2 + y.^2 - e*cos(f)*z.^2)./2 - (1-mu)./r1 - mu./r2;
if conv
    U = U - mu*(1-mu)/2;
end

%Changelog
%Date               Programmer              Action
%02/09/2022         Jared T. Blanchard      file created

% int(S,a,b) is the definite integral of S with respect to its
%       symbolic variable from a to b. a and b are each double or
%       symbolic scalars. The integration interval can also be specified
%       using a row or a column vector with two elements, i.e., valid
%       calls are also int(S,[a,b]) or int(S,[a b]) and int(S,[a;b]).
%  