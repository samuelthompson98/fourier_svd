
function plot_data_pdf(data_pdf)

norm  = stats(data_pdf.IPx)
data_out.IPx      = data_pdf.IPx;
data_out.IPx(:,2) = data_out.IPx(:,2)/norm.int(2);


set(0,'DefaultFigureVisible','on'); 
figure; hold on;
set(gca,'FontSize', 20, 'LineWidth',2.5,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

plot(data_pdf.Px(:,1),  data_pdf.Px(:,2),'k-');
plot(data_out.IPx(:,1), data_out.IPx(:,2),'k--')
set(gca, 'YScale','log')
ymin = 0.001; 
ymax = 10;
xmin = min(data_pdf.Px(:,1));
xmax = max(data_pdf.Px(:,1));
axis([xmin xmax ymin ymax])

return;
