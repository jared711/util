function plotCovariance(Sigma)
    x1 = linspace(-5,5,100);
    x2 = linspace(-5,5,100);
    for i = 1:100
        for j = 1:100
            x = [x1(i);x2(j)];
            f(i,j) = x'*Sigma*x;
        end
    end
    figure()
    contour(x1,x2,f)
end