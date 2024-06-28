% takes in states and converts them to the cylindrical coordinate
% system from Travis' thesis

function [x_new, r, theta] = cylindricalIsomorphicMapping(rvs)
% assume rv is a matrix made up of vectors

[n,N] = size(rvs);
if (n ~= 6) && (n ~= 4)
    if (N == 6) || (N == 4)
        rvs = rvs';
        [n,N] = deal(N,n);
    else
        error("rvs should be 6xN or 4xN")
    end
end

x_new = zeros(1,N);
r = zeros(1,N);
theta = zeros(1,N);

if n == 6;  warning("Make sure we're working in the planar problem");   end

for i = 1:N
    rv = rvs(:,i);
    C = jacobi_constant(rv);
    if n == 4
        x = rv(1);  y = rv(2);  xdot = rv(3);   ydot = rv(4);
    elseif n == 6
        x = rv(1);  y = rv(2);  xdot = rv(4);   ydot = rv(5);
    end

x_new(i) = x; % x-coordinate doesn't change. Distance along tube
y_new = zvs_y(x,C); % maximum distance possible from x-axis
r(i) = (y_new - y)/(2*y_new); % ratio of y value to maximum y value
theta(i) = atan2(ydot,xdot); % quadrant specific angle of velocity vector

end