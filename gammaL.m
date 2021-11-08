function [gamma] = gammaL(mu, Lpt)
% function gamma = gammaL(mu, Lpt)
%
% Calculate ratio of libration point distance from closest primary to distance
% between two primaries  (example gammaL1 = (E-L1)/AU)

mu2 = 1 - mu;

poly1 = [1  -1*(3-mu)  (3-2*mu)  -mu   2*mu  -mu ];
poly2 = [1     (3-mu)  (3-2*mu)  -mu  -2*mu  -mu ];
poly3 = [1     (2+mu)  (1+2*mu)  -mu2 -2*mu2 -mu2];

rt1 = roots(poly1); rt2 = roots(poly2); rt3 = roots(poly3);

for i=1:5
        if isreal(rt1(i)) GAMMAS(1)=rt1(i); end
        if isreal(rt2(i)) GAMMAS(2)=rt2(i); end
        if isreal(rt3(i)) GAMMAS(3)=rt3(i); end
end
gamma = GAMMAS(Lpt);
