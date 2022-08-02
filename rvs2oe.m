function [as, es, is, OMEGAs, omegas, nus] = rvs2oe(rvs, mu)
%RVS2OE Takes an array of states and converts them to orbital elements
% 
% [OUTPUTARGS] = RVS2OE(INPUTARGS)
% 
% Inputs: 
% 
% Outputs: 
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/06/16 15:02:25 	Revision: 0.1 $

[m,n] = size(rvs);
if m ~= 6
    if n == 6
        rvs = rvs';
        n = m;
    else
        error("rvs should be 6xN")
    end
end

for i = 1:n
    [as(i), es(i), is(i), OMEGAs(i), omegas(i), nus(i)] = rv2oe(rvs(:,i),mu);
end

    

end
