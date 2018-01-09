
function plot_spectra_pdf_fint(data_pdf, spectra_pdf)

fs = 12;  % font size
lw = 1.5; % line width

warning off;

Nf = size(spectra_pdf.IPFr, 1)
NP = size(spectra_pdf.IPFr, 2)

% Normalize pdf bins ================================================================
norm  = stats(data_pdf.IPx)
data_out.IPx      = data_pdf.IPx;
data_out.IPx(:,2) = data_out.IPx(:,2)/norm.int(2);

% integrate pdf over a frequency band,  if_min < index_f < if_max
% assumes all frequencies have the same 1:NP array 
if_min = 1;
if_max = Nf;

figure; hold on;
for i=1:Nf
  plot(spectra_pdf.IPFr(i,:,2)); hold on;
end;

temp(1:NP,1)  = spectra_pdf.IPFr(1,1:NP, 2).';
for j=1:NP
   temp(j,2) = sum(spectra_pdf.IPFr(if_min:if_max,j,3));
end;
norm  = stats(temp);
spectra_out.IPFr        = temp;
spectra_out.IPFr(:,2)   = spectra_out.IPFr(1:NP,2)/norm.int(2);


% Plot pdf bins ================================================================

set(0,'DefaultFigureVisible','on'); 
figure; hold on;
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

% plot data pdf 
% subplot('Position', [0.15 0.72 0.7 0.25]); hold on;
subplot(3,1,1); hold on;

set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
plot(data_pdf.Px(:,1),  data_pdf.Px(:,2),'k-');
plot(data_out.IPx(:,1), data_out.IPx(:,2),'kx--')
set(gca, 'YScale','log')

xmin = min(data_pdf.Px(:,1));
xmax = max(data_pdf.Px(:,1));
ymin = 0.1* min(data_pdf.Px(:,2));
ymax = 10* max(data_pdf.Px(:,2));

axis([xmin xmax ymin ymax])
xlabel(['x [V]'])
ylabel(['P(x) [V^{-1}]'])


% subplot('Position', [0.15 0.35 0.7 0.25]); hold on;
subplot(3,1,2); hold on;
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

[h1] = plot(spectra_out.IPFr(:,1),    spectra_out.IPFr(:,2),'bx-'); hold on;

return;
[h2] = plot(spectra_out.IPFi(i_freq,:,2),    spectra_out.IPFi(i_freq,:,3),'rx-');
[h3] = plot(spectra_out.IPFmag(i_freq,:,2),  spectra_out.IPFmag(i_freq,:,3),'kx-');
set(gca, 'YScale','log');

xmin = min(spectra_out.IPFr(i_freq,:,2));
xmax = max(spectra_out.IPFr(i_freq,:,2));
ymin = min(spectra_out.IPFr(i_freq,:,3))
ymax = max(spectra_out.IPFr(i_freq,:,3))
axis([xmin xmax ymin ymax]);

xlabel(['F_k [T Hz^{-1}]'])
ylabel(['P(F_k) [T^{-1} Hz]'])
legend([h1 h2 h3], 'P(X^r)', 'P(X^i)', 'P(|X|)')

% subplot('Position', [0.15 0.1 0.7 0.25]); hold on;
subplot(3,1,3); hold on;
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

plot(spectra_out.IPFph(i_freq,:,2), spectra_out.IPFph(i_freq,:,3),'kx-')
xlabel(['\angle F_k [rad s^{-1}]'])
ylabel(['P(\angle F_k) [rad^{-1} s]'])

warning on;

return;
