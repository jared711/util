function rv = rv_sizeCheck(rv)
%rv = rv_sizeCheck(rv)
%Output rv in appropriate format [6xN]

[n,m] = size(rv);
if n ~= 7 && n~= 6 && n~= 3 && n ~= 42
    if m == 7 || m == 6 || m == 3 || m == 42 
        rv = rv';
        n = m;
    else
        error("rv must be 7XN, 6xN, 3xN, or 42xN")
    end     
end

if n == 7
    rv = rv(1:6,:);
elseif n == 42
    rv = rv(37:42,:);
end

%Changelog
%Date           Programmer              Action
%02/22/2019     Jared T. Blanchard      file created 