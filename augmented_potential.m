function U = augmented_potential(x,y,z,mu,conv)
% U = aug_pot(x,y,z,mu,conv)

if nargin < 5;  conv = 1;           end
if nargin < 4;  global mu;          end
if nargin < 3;  z = zeros(size(x)); end

r1 = sqrt((x+mu).^2 + y.^2 + z.^2);
r2 = sqrt((x-1+mu).^2 + y.^2 + z.^2);
U = -(x.^2 + y.^2)./2 - (1-mu)./r1 - mu./r2;
if conv
    U = U - mu*(1-mu)/2;
end

%Changelog
%Date               Programmer              Action
%08/23/2019         Jared T. Blanchard      file created
