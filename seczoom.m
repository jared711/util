function seczoom(N)
global SEC mu RUNIT
if isempty(SEC);    SEC.radius = 1.7375e3;  end
if isempty(mu);     mu = 0.012150577032698; end
if isempty(RUNIT);  RUNIT = 384400;         end
if nargin < 1;      N = 5;                  end
r = SEC.radius/RUNIT;
axis([1-mu - N*r,1-mu + N*r,-N*r,N*r,-N*r,N*r])
end