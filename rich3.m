function [ss,rvi,period,Ax] = rich3(mu, Az, Lpt, NS, npts)
% function [ss,rvi,period,Ax] = rich3(mu, Az, Lpt, NS, npts)
% Also called richard3().
% Uses Richardson's 3rd order model for constructing an orbit about the 
% points L1, L2, L3
%
% 	 rv0 = richardson3(mu, Az, Lpt, NS, npts)
% 
% Gives initial conditions (r0,v0) for a halo orbit about Lpt=(1,2, or 3) with 
% amplitude Az (in units of the Lpt-nearest primary distance). 
% NS = 1 is northern(z>0, Class I), NS = 3 is southern(z<0, Class II)
% For class definition see Richardson
% Returns the 3x1 position matrix r0 and the 3x1 velocity matrix v0
% r0 and v0 are transformed into the CR3BP with the LARGER mass on the left
% npts = number of points on halo to return, equally spaced by time.

%  CONVENTION
%
%                 L4
% 
%    L3-----M1-------L1---M2---L2         M1=1-mu, M2=mu
%
%                 L5
if nargin < 5
   npts=1;
end

gamma = gammaL(mu, Lpt);
if Lpt == 1
   won =  1; primary = 1-mu;
elseif Lpt == 2
   won = -1; primary = 1-mu;
elseif Lpt == 3
   won =  1; primary = -mu;
end

if Lpt == 3
  for N = 2:4
    c(N)= (1/gamma^3)*( 1-mu + (-primary*gamma^(N+1))/((1+gamma)^(N+1)) );
  end
else
  for N = 2:4
    c(N)= (1/gamma^3)*( (won^N)*mu + ((-1)^N)*((primary)*gamma^(N+1))/((1+(-won)*gamma)^(N+1)) );
  end
end

polylambda = [ 1 0 (c(2)-2) 0 -(c(2)-1)*(1+2*c(2)) ];
lambdaroots = roots(polylambda); % lambda = frequency of orbit
if Lpt==3
   lambda = lambdaroots(1);
else
   lambda = lambdaroots(1);
end

k   = 2*lambda/(lambda^2 + 1 - c(2));


del = lambda^2 - c(2);

d1  = ((3*lambda^2)/k)*(k*( 6*lambda^2 -1) - 2*lambda);
d2  = ((8*lambda^2)/k)*(k*(11*lambda^2 -1) - 2*lambda);

a21 = (3*c(3)*(k^2 - 2))/(4*(1 + 2*c(2)));
a22 = 3*c(3)/(4*(1 + 2*c(2)));
a23 = -(3*c(3)*lambda/(4*k*d1))*( 3*(k^3)*lambda - 6*k*(k-lambda) + 4);
a24 = -(3*c(3)*lambda/(4*k*d1))*( 2 + 3*k*lambda );

b21 = -(3*c(3)*lambda/(2*d1))*(3*k*lambda - 4);
b22 = 3*c(3)*lambda/d1;
d21 = -c(3)/(2*lambda^2);

a31 = -(9*lambda/(4*d2))*(4*c(3)*(k*a23 - b21) + k*c(4)*(4 + k^2)) + ((9*lambda^2 + 1 -c(2))/(2*d2))*(3*c(3)*(2*a23 - k*b21) + c(4)*(2 + 3*k^2));
a32 = -(1/d2)*( (9*lambda/4)*(4*c(3)*(k*a24 - b22) + k*c(4)) + 1.5*(9*lambda^2 + 1 - c(2))*( c(3)*(k*b22 + d21 - 2*a24) - c(4)) );

b31 = (.375/d2)*( 8*lambda*(3*c(3)*(k*b21 - 2*a23) - c(4)*(2 + 3*k^2)) + (9*lambda^2 + 1 + 2*c(2))*(4*c(3)*(k*a23 - b21) + k*c(4)*(4 + k^2)) );
b32 = (1/d2)*( 9*lambda*(c(3)*(k*b22 + d21 - 2*a24) - c(4)) + .375*(9*lambda^2 + 1 + 2*c(2))*(4*c(3)*(k*a24 - b22) + k*c(4)) );

d31 = (3/(64*lambda^2))*(4*c(3)*a24 + c(4));
d32 = (3/(64*lambda^2))*(4*c(3)*(a23- d21) + c(4)*(4 + k^2));

s1  = (1/(2*lambda*(lambda*(1+k^2) - 2*k)))*( 1.5*c(3)*(2*a21*(k^2 - 2)-a23*(k^2 + 2) - 2*k*b21) - .375*c(4)*(3*k^4 - 8*k^2 + 8) );
s2  = (1/(2*lambda*(lambda*(1+k^2) - 2*k)))*( 1.5*c(3)*(2*a22*(k^2 - 2)+a24*(k^2 + 2) + 2*k*b22 + 5*d21) + .375*c(4)*(12 - k^2) );

a1  = -1.5*c(3)*(2*a21+ a23 + 5*d21) - .375*c(4)*(12-k^2);
a2  =  1.5*c(3)*(a24-2*a22) + 1.125*c(4);

l1 = a1 + 2*(lambda^2)*s1;
l2 = a2 + 2*(lambda^2)*s2;

% ADDITIONAL TERMS FROM GEOMETRY CENTER PAPER
b33 = -k/(16*lambda)*(12*c(3)*(b21-2*k*a21+k*a23)+3*c(4)*k*(3*k^2-4)+16*s1*lambda*(lambda*k-1));
b34 = -k/(8*lambda)*(-12*c(3)*k*a22+3*c(4)*k+8*s2*lambda*(lambda*k-1));
b35 = -k/(16*lambda)*(12*c(3)*(b22+k*a24)+3*c(4)*k);

deltan = 2 - NS;

Ax  = sqrt( (-del - l2*Az^2)/l1 );
omg = 1+s1*Ax^2+s2*Az^2;
freq=lambda*omg;
period=2*pi/freq;

rvi  = zeros(npts,6);
ss   = zeros(npts,1);
if npts > 1
   dtau1= 2*pi/(npts-1);
else
   dtau1= 2*pi;
end
tau1 = 0;
for i=1:npts
x = a21*Ax^2 + a22*Az^2 - Ax*cos(tau1) + (a23*Ax^2 - a24*Az^2)*cos(2*tau1) + (a31*Ax^3 - a32*Ax*Az^2)*cos(3*tau1);
y = k*Ax*sin(tau1) + (b21*Ax^2 - b22*Az^2)*sin(2*tau1) + (b31*Ax^3 - b32*Ax*Az^2)*sin(3*tau1);
z = deltan*Az*cos(tau1) + deltan*d21*Ax*Az*(cos(2*tau1) - 3) + deltan*(d32*Az*Ax^2 - d31*Az^3)*cos(3*tau1);
y_plus = (b33*Ax^3 + b34*Ax*Az^2 - b35*Ax*Az^2)*sin(tau1);
y = y + y_plus;     % ADD EXTRA TERMS FROM G.C. PAPER

xdot = freq*Ax*sin(tau1) - 2*freq*(a23*Ax^2-a24*Az^2)*sin(2*tau1) - 3*freq*(a31*Ax^3 - a32*Ax*Az^2)*sin(3*tau1);
ydot = freq*(k*Ax*cos(tau1) + 2*(b21*Ax^2 - b22*Az^2)*cos(2*tau1) + 3*(b31*Ax^3 - b32*Ax*Az^2)*cos(3*tau1));
zdot = - freq*deltan*Az*sin(tau1) - 2*freq*deltan*d21*Ax*Az*sin(2*tau1) - 3*freq*deltan*(d32*Az*Ax^2 - d31*Az^3)*sin(3*tau1);
ydot_plus = freq*(b33*Ax^3 + b34*Ax*Az^2 - b35*Ax*Az^2)*cos(tau1);
ydot = ydot_plus + ydot; % ADD EXTRA TERMS FROM G.C. PAPER

rvi(i,:)= gamma*[ (primary+gamma*(-won+x))/gamma, y, z, xdot, ydot, zdot]';
ss(i)   = tau1/freq;
tau1=tau1+dtau1;
end
