% MJH 12/10/05
% Plot cdfs F(r) for M=1, M=2, mock data (uniform and gaussian pdfs) and plasma noise
% Plot cdfs F(r|n) for M=1, M=2, mock data (uniform and gaussian pdfs) and plasma noise

% load uniform_noise.mat pdf1 pdf2
load noise.mat pdf1_unfrm pdf2_unfrm pdf1_gauss pdf2_gauss pdf1_data pdf2_data

% uniform noise -------------------------------------------
pdf1 = pdf1_unfrm;
pdf2 = pdf2_unfrm;

R1bins= length(pdf1.rbin);
R2bins= length(pdf2.rbin);

% plot pdfs P(r) vs. r together for M=1, M=2

% sum over F1bins and N1bins 
for i=1:R1bins
  pdf1.Pr(i) = sum(pdf1.Pnr(:,i));
  pdf1.Fr(i) = sum(pdf1.Fnr(:,i));
end;

pdf1.Pr = pdf1.Pr/pdf1.Fr(R1bins)
pdf1.Fr = pdf1.Fr/pdf1.Fr(R1bins)

% sum over F2bins and N2bins 
for i=1:R2bins
  pdf2.Pr(i) = sum(pdf2.Pnr(:,i));
  pdf2.Fr(i) = sum(pdf2.Fnr(:,i));
end;

pdf2.Pr = pdf2.Pr/pdf2.Fr(R2bins)
pdf2.Fr = pdf2.Fr/pdf2.Fr(R2bins)

pdf1_unfrm = pdf1;
pdf2_unfrm = pdf2;

% Gaussian noise -------------------------------------------
pdf1 = pdf1_gauss;
pdf2 = pdf2_gauss;

R1bins= length(pdf1.rbin);
R2bins= length(pdf2.rbin);

% plot pdfs P(r) vs. r together for M=1, M=2

% sum over F1bins and N1bins 
for i=1:R1bins
  pdf1.Pr(i) = sum(pdf1.Pnr(:,i));
  pdf1.Fr(i) = sum(pdf1.Fnr(:,i));
end;

pdf1.Pr = pdf1.Pr/pdf1.Fr(R1bins)
pdf1.Fr = pdf1.Fr/pdf1.Fr(R1bins)

% sum over F2bins and N2bins 
for i=1:R2bins
  pdf2.Pr(i) = sum(pdf2.Pnr(:,i));
  pdf2.Fr(i) = sum(pdf2.Fnr(:,i));
end;

pdf2.Pr = pdf2.Pr/pdf2.Fr(R2bins)
pdf2.Fr = pdf2.Fr/pdf2.Fr(R2bins)

pdf1_gauss = pdf1;
pdf2_gauss = pdf2;


% Data noise -------------------------------------------
pdf1 = pdf1_data;
pdf2 = pdf2_data;

R1bins= length(pdf1.rbin);
R2bins= length(pdf2.rbin);

% plot pdfs P(r) vs. r together for M=1, M=2

% sum over F1bins and N1bins 
for i=1:R1bins
  pdf1.Pr(i) = sum(pdf1.Pnr(:,i));
  pdf1.Fr(i) = sum(pdf1.Fnr(:,i));
end;

pdf1.Pr = pdf1.Pr/pdf1.Fr(R1bins)
pdf1.Fr = pdf1.Fr/pdf1.Fr(R1bins)

% sum over F2bins and N2bins 
for i=1:R2bins
  pdf2.Pr(i) = sum(pdf2.Pnr(:,i));
  pdf2.Fr(i) = sum(pdf2.Fnr(:,i));
end;

pdf2.Pr = pdf2.Pr/pdf2.Fr(R2bins)
pdf2.Fr = pdf2.Fr/pdf2.Fr(R2bins)

pdf1_data = pdf1;
pdf2_data = pdf2;

% plots ---------------------------------------------------------
h = figure;
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

plot(pdf1_unfrm.rbin, pdf1_unfrm.Fr, 'k-','LineWidth', 2);
plot(pdf2_unfrm.rbin, pdf2_unfrm.Fr, 'k-','LineWidth', 1);

plot(pdf1_gauss.rbin, pdf1_gauss.Fr, 'k:','LineWidth', 2);
plot(pdf2_gauss.rbin, pdf2_gauss.Fr, 'k:','LineWidth', 1);

plot(pdf1_data.rbin, pdf1_data.Fr, 'k--','LineWidth', 2);
plot(pdf2_data.rbin, pdf2_data.Fr, 'k--','LineWidth', 1);

plot([0 1], [0.01 0.01],'k--','LineWidth', 1);
plot([0 1], [0.05 0.05],'k--','LineWidth', 1);
plot([0 1], [0.10 0.10],'k--','LineWidth', 1);
plot([0 1], [0.50 0.50],'k--','LineWidth', 1);

xlabel(['r']);
ylabel(['F(r)']);

set(gca,'XTick',[0, 0.2, 0.4, 0.6, 0.8, 1.0])

save noise_gauss.mat pdf1_gauss pdf2_gauss

return;

