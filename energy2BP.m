function E = energy2BP(x,mu)
if nargin < 2; global PRIM; mu = PRIM.gm; end
r = norm(x(1:3));
v = norm(x(4:6));
E = v^2/2 - mu/r;
end