function nu = E2nu(E,e)

nu = 2*atan(sqrt((1+e)/(1-e))*tan(E/2));

while nu >= 2*pi
    nu = nu-2*pi;
end
while nu < 0
    nu = nu + 2*pi;
end

end