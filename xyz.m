function [] = xyz(txt)
if nargin < 1;  txt = "";   end
xlabel("X" + txt)
ylabel("Y" + txt)
zlabel("Z" + txt)
end