function plot_lpts(lpts, idx, col)

if nargin < 3; col = "k";           end
if nargin < 2; idx = 1:5;           end
if nargin < 1; lpts = CR3BPLpts();  end

[n, m] = size(lpts);
if n ~= 3 && m == 3 
    lpts = lpts';
end

gcf
hold on
for i = idx
    plot3(lpts(1,i), lpts(2,i), lpts(3,i), col+"x", "HandleVisibility","off",'MarkerSize',12)
end
grid('on');
end