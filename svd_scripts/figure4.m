
% NB: Use form_figure4.m to generate data for plot

% figure 4
file = 'MC_9429';
file = 'MC_tempb';
file = 'MC_9425d';

load(file,'data_pdf','spectra_pdf')
[fit_pdf, data_out, spectra_out] = plot_spectra_pdf(data_pdf(1), spectra_pdf(1));

save MC_9425_pdfs.mat data_out spectra_out fit_pdf;

subplot(3,1,2); hold on;

% suppose frequency mismatch
% fit_pdf.freq  = fit_pdf.freq/10;

% load 9425_Ffit.mat pfit
% axmag    = axis;
% Fval     = exp(pfit(2))*fit_pdf.freq^pfit(1);
% Fnorm    = 1e-6;
% plot([Fval/Fnorm Fval/Fnorm], [axmag(3) axmag(4)],'r'); 

load 9425_afit.mat pfit
axmag    = axis;
alphaval = exp(pfit(2))*fit_pdf.freq^pfit(1);
Fnorm    = 1e-6;
plot([alphaval/Fnorm alphaval/Fnorm], [axmag(3) axmag(4)],'b'); 

ifreq    = find(fit_pdf.freq == spectra_out.IPFmag(:,1,1));
NP       = size(spectra_out.IPFmag, 2); 
clear temp
for i=1:NP
    temp(i,1) = spectra_out.IPFmag(ifreq,i,2);
    temp(i,2) = spectra_out.IPFmag(ifreq,i,3);
end
ss = stats(temp);
plot([ss.mu(2)/Fnorm ss.mu(2)/Fnorm], [axmag(3) axmag(4)],'g'); 

return

