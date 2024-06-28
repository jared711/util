function thetadot = thetadot(rv,mu)

if nargin < 2;  global mu;  end


if length(rv) == 6
    rvdot = CR3BP(0,rv,mu);
    xdot = rvdot(1);   
    ydot = rvdot(2);
    xddot = rvdot(4);
    yddot = rvdot(5);
elseif length(rv) == 4
    rvdot = PCR3BP(0,rv,mu);
    xdot = rvdot(1);   
    ydot = rvdot(2);   
    xddot = rvdot(3);
    yddot = rvdot(4);
end

den = xdot^2 + ydot^2; % denominator term (from derivative of atan2)
num = xdot*yddot - ydot*xddot; % numerator term (from derivative of atan2 plus time derivatives of dot terms)
thetadot = num/den;

end