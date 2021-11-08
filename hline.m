function hline(height,xf,x0)
if nargin < 3;  x0 = 0; end
plot([x0,xf],[height,height],'--')
end