function [a, e, i, OMEGA, omega, nu] = rv2oe(rv,mu)

if nargin < 2;  mu = 3.986e5;   end % [km^3/s^2]

if ~iscolumn(rv)
    rv = rv';
end

r = rv(1:3);
v = rv(4:6);

%specific angular momentum
h = cross(r,v);
% directions of angular momentum
W = h/norm(h);

i = atan2(sqrt((h(1)/norm(h))^2+(h(2)/norm(h))^2),(h(3)/norm(h)));
%i = sqrt((W(1))^2+(W(2))^2)/(W(3));

if i == 0 || i == pi/2
    OMEGA = NaN;
else
    OMEGA = atan2(h(1),-h(2));
    %OMEGA = atan2(W(1)/-W(2));
end

p = norm(h)^2/mu;

a = (2/norm(r) - norm(v)^2/mu)^(-1);

e = sqrt(1 - p/a);

if a < 0
    nu = NaN;
    omega = NaN;
else
    n = sqrt(mu/a^3);

    E = atan2((r'*v)/(n*a^2),(1-norm(r)/a));

    nu = E2nu(E,e);

    u = atan2(r(3)/sin(i),r(1)*cos(OMEGA) + r(2)*sin(OMEGA));
    
    omega = u-nu;
end
end

% Created by Jared Blanchard 05/06/2020 from AA279A code