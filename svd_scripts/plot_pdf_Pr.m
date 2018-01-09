

function plot_pdf_Pr(pdf1,pdf2, varargin)

R1bins= length(pdf1.rbin);
R2bins= length(pdf2.rbin);

% plot pdfs P(r) vs. r together for M=1, M=2

% sum over F1bins and N1bins 
temp1 = sum(sum(pdf1.Pnr));
for i=1:R1bins
  pdf1.Pr(i) = temp1(1,1,i);
  pdf1.Fr(i) = sum(pdf1.Pr(1:i));
end;

% sum over F2bins and N2bins 
temp2 = sum(sum(pdf2.Pnr));
for i=1:R2bins
  pdf2.Pr(i) = temp2(1,1,i);
  pdf2.Fr(i) = sum(pdf2.Pr(1:i));
end;

if ~isempty(varargin)
  h = varargin{1};
  figure(h);
else 
  h = figure;
end;
set(gca,'FontSize', 20, 'LineWidth',2.5,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

ltype(1).Color     = 'k';
ltype(1).LineWidth = 2;
ltype(1).Marker = 'None';
ltype(1).MarkerFaceColor = 'k';
ltype(2) = ltype(1);
ltype(3) = ltype(1);
ltype(4) = ltype(1);

ltype(1).LineStyle = '-';
ltype(2).LineStyle = '--';
ltype(3).LineStyle = ':';
ltype(4).LineStyle = '-.';

% plot(pdf1.rbin, pdf1.Pr, 'k-','LineWidth', 2);
plot(pdf1.rbin, pdf1.Fr, 'k-.','LineWidth', 3);

% plot(pdf2.rbin, pdf2.Pr, 'k:','LineWidth', 2);
plot(pdf2.rbin, pdf2.Fr, 'k-.','LineWidth', 1);

% ylabel('P(r), F(r)');
axis([0 1 0 1]);

return;

