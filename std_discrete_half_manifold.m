function xx = std_discrete_half_manifold(x_eq, lambda, v, N)
xx = zeros(N,6);
alpha = find_alpha(x_eq, lambda, v);
for i = 1:N
    xx(i,:) = x_eq + (1+(i-1)*(lambda-1)/N)*alpha*v;
end
end