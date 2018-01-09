

function plot_pdf_Prn(pdf1,pdf2,varargin)

R1bins= length(pdf1.rbin);
N1bins= length(pdf2.nbin);

R2bins= length(pdf2.rbin);
N2bins= length(pdf2.nbin);

% plot pdfs P(r) vs. r together for M=1, M=2

% sum over F1bins 
temp1 = sum(pdf1.Pnr);
for i=1:R1bins
  for j=1:N1bins
    pdf1.Pr(i,j) = temp1(1,j,i);
    pdf1.Fr(i,j) = sum(pdf1.Pr(1:i,j));
  end;
end;

% sum over F2bins 
temp2 = sum(pdf2.Pnr);
for i=1:R2bins
  for j=1:N2bins
    pdf2.Pr(i,j) = temp2(1,j,i);
    pdf2.Fr(i,j) = sum(pdf2.Pr(1:i,j));
  end;
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

for j=1:N1bins
  plot(pdf1.rbin, pdf1.Fr(:,j), 'kx-','LineWidth', 1);
end;

for j=1:N2bins
  plot(pdf2.rbin, pdf2.Fr(:,j), 'kx-.','LineWidth', 1);
end;

ylabel('F(r|n)');

ymax = max([max(max(pdf1.Fr)) max(max(pdf2.Fr))]);
axis([0 1 0 ymax]);

return;

