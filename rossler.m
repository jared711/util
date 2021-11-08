function X_dot = rossler(t,X)
x = X(1);
y = X(2);
z = X(3);

a = 0.2;
b = 0.2;
c = 2.5;

X_dot = zeros(3,1);

X_dot(1) = -y-z;
X_dot(2) = x+a*y;
X_dot(3) = b+z*(x-c);
end
