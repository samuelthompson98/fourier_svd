function [pdf] = plot_stats

load n1_gauss_10k.mat pdf1_gauss
% load n1_gauss.mat pdf1_gauss

fsize  = 14;
blsize = 1.5;
lsize  = 1.5;

h = figure;
title(['Nph = ',num2str(pdf1_gauss.Nph)]);

set(gca,'FontSize', fsize, 'LineWidth',blsize,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

subplot(3,1,1);
h1 = plot(pdf1_gauss.rbin, pdf1_gauss.Fr,'k','LineWidth',lsize); hold on;
set(gca,'FontSize', fsize, 'LineWidth',blsize,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
xlabel(['r']);
ylabel(['C(r)']);
title(['Nph = ',num2str(pdf1_gauss.Nph)]);
axis([0 1 0 1.1]);

subplot(3,1,2);
h2 = plot(pdf1_gauss.nbin, pdf1_gauss.Fn,'k','LineWidth',lsize); hold on;
set(gca,'FontSize', fsize, 'LineWidth',blsize,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
xlabel(['n']);
ylabel(['C(n)']);
x1 = min(pdf1_gauss.nbin);
x2 = max(pdf1_gauss.nbin);
axis([x1 x2 0 1.1]);


subplot(3,1,3);
set(gca,'FontSize', fsize, 'LineWidth',blsize,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

junk.Pa(:,1) = pdf1_gauss.abin;
junk.Pa(:,2) = pdf1_gauss.Pa;
pdf1_gauss.Pa_stats = stats(junk.Pa);
pdf1_gauss.amean    = pdf1_gauss.Pa_stats.mu(2);

h3 = plot(pdf1_gauss.abin/pdf1_gauss.amean, pdf1_gauss.Fa,'k','LineWidth',lsize); hold on;

Abins      = length(pdf1_gauss.abin)
xpdf.sigma = 2 * pdf1_gauss.amean/ sqrt(pi);
xpdf.abin  = pdf1_gauss.abin;
for i=1:Abins
    xpdf.Fa(i) = 1 -  exp(-xpdf.abin(i)^2/xpdf.sigma^2);
end;
plot(xpdf.abin/pdf1_gauss.amean,  xpdf.Fa,'k:','LineWidth',lsize); hold on;

x1 = min(xpdf.abin/pdf1_gauss.amean); 
x2 = max(xpdf.abin/pdf1_gauss.amean);
y1 = min( xpdf.Fa); 
y2 = max( xpdf.Fa); 
y1 = 10^(-3);
y2 = 1.5
axis([x1 x2 0 1.1]);
% set(gca,'YScale','Log');
% set(gca,'YTick',[0 1])
xlabel(['|\alpha|/<|\alpha|>']);
ylabel(['C(|\alpha|/<|\alpha|>)']);

pdf = pdf1_gauss


return