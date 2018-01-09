

function plot_pdfs(pdf)

fbin = pdf.fbin;
nbin = pdf.nbin;
rbin = pdf.rbin;
Pn   = pdf.Pn;
Fn   = pdf.Fn;
Pnr  = pdf.Pnr;
Fnr  = pdf.Fnr;

Nbins= length(nbin);
Fbins= length(fbin);
Rbins= length(rbin);
Ns   = Nbins - 1;
Nc   = Ns/2;

figure; % subplot(2,1,1);
set(gca,'FontSize', 20, 'LineWidth',2.5,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

ltype(1).Color     = 'k';
ltype(1).LineWidth = 2;
ltype(1).Marker = 'o';
ltype(1).MarkerFaceColor = 'k';
ltype(2) = ltype(1);
ltype(3) = ltype(1);
ltype(4) = ltype(1);

ltype(1).LineStyle = '-';
ltype(2).LineStyle = '--';
ltype(3).LineStyle = ':';
ltype(4).LineStyle = '-.';

bar(nbin, Pn.',1.0,'group')
ylabel('P_n');
ymax = max(max(pdf.Pn));
axis([-Nc Nc 0 ymax]);
colormap gray

% for k=1:Fbins
%   plot(nbin, Pn(k,:), ltype(k));
% end;

figure; % subplot(2,1,2);
set(gca,'FontSize', 20, 'LineWidth',2.5,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

% for k=1:Fbins
%   plot(nbin, Fn(k,:), ltype(k));
% end;

bar(nbin, Fn.',1.0,'group')
ymax = max(max(pdf.Fn));
axis([-Nc Nc 0 ymax]);
colormap gray
ylabel('F_n');
xlabel('n');



return;
