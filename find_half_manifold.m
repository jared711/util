function find_half_manifold(xeq, vu, h)
M = 1;
N = 1;
alpha = find_alpha(xeq, M, nu);
x_alpha = xeq + alpha*vu;
output xeq
output x_alpha
for k = 1:N
    output phi_kh(x_alpha)
end
end