N = 30;
yy = ceil(rand(N,1)*50);
xx = 1:N;
str = cell(1,N);
for pp = 1:N
    str{pp} = sprintf('Sample %d',pp);
end
reer = plot(xx,yy,'-o');
sadf = dataTipTextRow('ID =',str);
reer.DataTipTemplate.DataTipRows(end+1:end+2) = sadf;
reer.DataTipTemplate.DataTipRows(3) = reer.DataTipTemplate.DataTipRows(1);
reer.DataTipTemplate.DataTipRows(1) = reer.DataTipTemplate.DataTipRows(4);
reer.DataTipTemplate.DataTipRows = reer.DataTipTemplate.DataTipRows(1:3);
reer.DataTipTemplate.DataTipRows(2).Label = 'Your Y Data =';
reer.DataTipTemplate.DataTipRows(3).Label = 'Your X Data =';
reer.DataTipTemplate.DataTipRows(4).Label = 'Whatever';