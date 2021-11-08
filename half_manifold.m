function xx = half_manifold(x_eq, lambda, v)
E_r = 1e-10;
E_alpha = 1e-10;
n_pts = 100;

initialize(x_eq, lambda, v);
end

function [alpha, x_bar] = initialize(x_star, lambda, v)
alpha = find_alpha(x_star, lambda, v);
x_bar(1,:) = x_star + alpha*v;


end

