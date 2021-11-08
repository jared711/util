function cobweb_diagram(, x_n)
figure;
hold on
legend_entries = [""];
r = 3.8;
title(['r = ', num2str(r)])
dir = strcat("OrbitalResearch/misc/");
plotDescription = strcat("cobweb_", num2str(r));

xlabel('x_n')
ylabel('x_{n+1}')
x_n1 = f(.x_n);    
plot(x_n, x_n1)
plot(x_n, x_n)

x = [0.5; 0];
cobweb = [x];
for i = 1:100
    x(2) = r*x(1)*(1-x(1));
    cobweb = [cobweb, x];
    x(1) = x(2);
    cobweb = [cobweb, x];
end
plot(cobweb(1,:), cobweb(2,:))
% axis([x_n(1), x_n(end), 0, r/4])
axis equal


savefig(strcat(dir,plotDescription,".fig"));
saveas(gcf,strcat(dir,plotDescription,".jpg"))

end