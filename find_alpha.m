function alpha = find_alpha(x_star, lambda, v)
%These need to be chosen
if ~iscolumn(x_star)
    x_star = x_star';
elseif ~iscolumn(v)
    v = v';
end

E_r = 1e-10;
E_alpha = 1e-10;
alpha_min = 1e-10;
alpha_max = 1.0;
alpha = 2.0*alpha_max;

x = x_star + alpha*v;
px = x + alpha*lambda*v;
pLx = x_star + alpha*lambda*v;
while (norm(px - pLx) > E_r*norm(px) + E_alpha)
    alpha = alpha/2.0;
    if (alpha < alpha_min)
        alpha = alpha_min;
        break
    end
    x = x_star + alpha*v;
    px = x + alpha*lambda*v;
    pLx = x_star + alpha*lambda*v;
end
end