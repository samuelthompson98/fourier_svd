
function [fit_pdf, data_out, spectra_out] = plot_spectra_pdf(data_pdf, spectra_pdf)

global signal_pdf

fs = 12;  % font size
lw = 1.5; % line width

warning off;

Nf = size(spectra_pdf.IPFr, 1);
NP = size(spectra_pdf.IPFr, 2);

% Normalize pdf bins ================================================================
norm  = stats(data_pdf.IPx)
data_out.IPx      = data_pdf.IPx;
data_out.IPx(:,2) = data_out.IPx(:,2)/norm.int(2);

spectra_out = spectra_pdf;
for i=1:Nf
    temp(1:NP,1)  = spectra_pdf.IPFr(i,1:NP, 2).';
    temp(1:NP,2)  = spectra_pdf.IPFr(i,1:NP, 3).';
    norm  = stats(temp);
    spectra_out.IPFr(i,1:NP,3)    = spectra_out.IPFr(i,1:NP,3)/norm.int(2);
    
    temp(1:NP,1)  = spectra_pdf.IPFi(i,1:NP, 2).';
    temp(1:NP,2)  = spectra_pdf.IPFi(i,1:NP, 3).';
    norm  = stats(temp);
    spectra_out.IPFi(i,1:NP,3)    = spectra_out.IPFi(i,1:NP,3)/norm.int(2);
    
    temp(1:NP,1)  = spectra_pdf.IPFmag(i,1:NP, 2).';
    temp(1:NP,2)  = spectra_pdf.IPFmag(i,1:NP, 3).';
    norm  = stats(temp);
    spectra_out.IPFmag(i,1:NP,3)    = spectra_out.IPFmag(i,1:NP,3)/norm.int(2);
    
    temp(1:NP,1)  = spectra_pdf.IPFph(i,1:NP, 2).';
    temp(1:NP,2)  = spectra_pdf.IPFph(i,1:NP, 3).';
    norm  = stats(temp);
    spectra_out.IPFph(i,1:NP,3)    = spectra_out.IPFph(i,1:NP,3)/norm.int(2);
end;


% fit to Gaussian pdf =====================================================

  % MJH 08/03/07 - boost effective fit resolution by factor of 100
  % NP = 100*NP;

  % increase range of data_pdf.Px by factor rmul
  xmin = min(data_pdf.Px(:,1));
  xmax = max(data_pdf.Px(:,1));
  rmul = 1.5;
  xpmin = (xmin+xmax)/2 - rmul*(xmax-xmin)/2;
  xpmax = (xmin+xmax)/2 + rmul*(xmax-xmin)/2;
  dxp   = (xpmax - xpmin)/(NP-1); 
  data_pdf.Px(:,1) = (xpmin : dxp : xpmax).';
    
  for j=1:NP
    data_pdf.Px(j,2) = 1/(sqrt(2*pi)*data_pdf.sigma) * exp(-(data_pdf.Px(j,1) - data_pdf.mu)^2/(2*(data_pdf.sigma)^2));
  end;

  fit_pdf.Px_mu    = data_pdf.mu
  fit_pdf.Px_sigma = data_pdf.sigma
  
  fref   = 18.5e+3;
  i_freq = min(find(spectra_out.IPFr(:,1,1)>fref));
  fit_pdf.freq = spectra_out.IPFr(i_freq,1,1);
  
  fit = 1;
  if fit 
      
    % fit IPFr ---------------------------------------
    signal_pdf.Px(:,1) = spectra_out.IPFr(i_freq,:,2);
    signal_pdf.Px(:,2) = spectra_out.IPFr(i_freq,:,3);
  
    xmin = min(signal_pdf.Px(:,1));
    xmax = max(signal_pdf.Px(:,1));

    x0(1) = (xmin+xmax)/2;
    x0(2) = (xmax-xmin)/2;

    OPTIONS = OPTIMSET('MaxIter', 100, 'MaxFunEvals', 1e+5, 'TolFun', 1e-6,'Display', 'iter');  
    x = fminsearch(@gaussfit_res,x0, OPTIONS)

    % construct fit
    fit_pdf.PFr_mu    = x(1);
    fit_pdf.PFr_sigma = x(2);

    % increase range of fit_pdf.PFr by factor rmul
    xpmin = (xmin+xmax)/2 - rmul*(xmax-xmin)/2;
    xpmax = (xmin+xmax)/2 + rmul*(xmax-xmin)/2;
    dxp   = (xpmax - xpmin)/(NP-1); 
    fit_pdf.PFr(:,1) = (xpmin : dxp : xpmax).';
    
    for j=1:NP
      fit_pdf.PFr(j,2) = 1/(sqrt(2*pi)*fit_pdf.PFr_sigma) * exp(-(fit_pdf.PFr(j,1) - fit_pdf.PFr_mu)^2/(2*(fit_pdf.PFr_sigma)^2));
    end;

    % fit IPFi ---------------------------------------
    signal_pdf.Px(:,1) = spectra_out.IPFi(i_freq,:,2);
    signal_pdf.Px(:,2) = spectra_out.IPFi(i_freq,:,3);
  
    xmin = min(signal_pdf.Px(:,1));
    xmax = max(signal_pdf.Px(:,1));

    x0(1) = (xmin+xmax)/2;
    x0(2) = (xmax-xmin)/2;

    OPTIONS = OPTIMSET('MaxIter', 100, 'MaxFunEvals', 1e+5, 'TolFun', 1e-6,'Display', 'iter');  
    x = fminsearch(@gaussfit_res,x0, OPTIONS)

    % construct fit
    fit_pdf.PFi_mu    = x(1);
    fit_pdf.PFi_sigma = x(2);

    fit_pdf.PFi(:,1) = fit_pdf.PFr(:,1);    
    for j=1:NP
      fit_pdf.PFi(j,2) = 1/(sqrt(2*pi)*fit_pdf.PFi_sigma) * exp(-(fit_pdf.PFi(j,1) - fit_pdf.PFi_mu)^2/(2*(fit_pdf.PFi_sigma)^2));
    end;

    % fit IPFmag : assume <Fr> = <Fi> = 0  ---------------------------------
    signal_pdf.Px(:,1) = spectra_out.IPFmag(i_freq,:,2);
    signal_pdf.Px(:,2) = spectra_out.IPFmag(i_freq,:,3);
  
    xmin = min(signal_pdf.Px(:,1));
    xmin = 1e-12;
    xmax = max(signal_pdf.Px(:,1));

    clear x0 x
    x0(1) = (xmax-xmin)/2;

    OPTIONS = OPTIMSET('MaxIter', 100, 'MaxFunEvals', 1e+5, 'TolFun', 1e-6,'Display', 'iter');  
    x = fminsearch(@xgaussfit_res,x0, OPTIONS)

    % construct fit    
    fit_pdf.PFmag_sigma = x(1);

    xpmin = xmin;
    xpmax = xmax * rmul;
    dxp   = (xpmax - xpmin)/(NP-1); 

    % pack grid near origin
    NPpack = 5;
    fit_pdf.PFmag(1:NPpack,1)    = (xpmin : dxp/(NPpack - 1) : dxp+xpmin).';
    fit_pdf.PFmag(NPpack+1:NP,1) = (dxp + xpmin : (xpmax - (dxp+xpmin))/(NP - NPpack - 1) : xpmax).';

    for j=1:NP
      fit_pdf.PFmag(j,2) = fit_pdf.PFmag(j,1)/(fit_pdf.PFmag_sigma^2) * exp(-(fit_pdf.PFmag(j,1))^2/(2*(fit_pdf.PFmag_sigma)^2));
    end;
  end; % fit

    
% Plot pdf bins ================================================================

set(0,'DefaultFigureVisible','on'); 
figure; hold on;
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

% plot data pdf 
% subplot('Position', [0.15 0.72 0.7 0.25]); hold on;
subplot(3,1,1); hold on;

set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
plot(data_pdf.Px(:,1),  data_pdf.Px(:,2),'k-');
plot(data_out.IPx(:,1), data_out.IPx(:,2),'k.', 'MarkerSize',6)
set(gca, 'YScale','log','YTick',[1e-4 1e+2])

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

Fnorm= 1e-6;

[h1] = plot(spectra_out.IPFr(i_freq,:,2)/Fnorm,    spectra_out.IPFr(i_freq,:,3),'.','Color','k', 'MarkerSize',6); hold on;
[h2] = plot(spectra_out.IPFi(i_freq,:,2)/Fnorm,    spectra_out.IPFi(i_freq,:,3),'.','Color',[0.75 0.75 0.75],'MarkerSize',6);
[h3] = plot(spectra_out.IPFmag(i_freq,:,2)/Fnorm,  spectra_out.IPFmag(i_freq,:,3),'ko','MarkerSize',3);

if fit 
    [h1fit] = plot(fit_pdf.PFr(:,1)/Fnorm,fit_pdf.PFr(:,2),'-','Color','k');
    [h2fit] = plot(fit_pdf.PFi(:,1)/Fnorm,fit_pdf.PFi(:,2),':','Color',[0.75 0.75 0.75]);
    [h3fit] = plot(fit_pdf.PFmag(:,1)/Fnorm,fit_pdf.PFmag(:,2),'k-');
    xmin = min([min(spectra_out.IPFr(i_freq,:,2))/Fnorm min(fit_pdf.PFr(:,1))/Fnorm]);
    xmax = max([max(spectra_out.IPFr(i_freq,:,2))/Fnorm max(fit_pdf.PFr(:,1))/Fnorm]);
    ymin = min([min(spectra_out.IPFr(i_freq,:,3)) min(spectra_out.IPFmag(i_freq,:,3)) min(fit_pdf.PFr(:,2))])
    ymax = max([max(spectra_out.IPFr(i_freq,:,3)) max(spectra_out.IPFmag(i_freq,:,3)) max(fit_pdf.PFr(:,2))])
    ymax = 10*ymax;
    ymin = 1e+2;
    ymax = 1e+7;
else
    
    xmin = min(spectra_out.IPFr(i_freq,:,2)/Fnorm);
    xmax = max(spectra_out.IPFr(i_freq,:,2)/Fnorm);
    ymin = min([min(spectra_out.IPFr(i_freq,:,3)) min(spectra_out.IPFmag(i_freq,:,3))])
    ymax = max([max(spectra_out.IPFr(i_freq,:,3)) max(spectra_out.IPFmag(i_freq,:,3))])
end;

set(gca, 'YScale','log','YTick',[1e+2 1e+6])

axis([xmin xmax ymin ymax]);

xlabel(['F_k [\mu T Hz^{-1}]'])
ylabel(['P(F_k) [(\mu T)^{-1} Hz]'])
legend([h1 h2 h3], 'P(X^r)', 'P(X^i)', 'P(|X|)')

% subplot('Position', [0.15 0.1 0.7 0.25]); hold on;
subplot(3,1,3); hold on;
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

plot(spectra_out.IPFph(i_freq,:,2), spectra_out.IPFph(i_freq,:,3),'k.','MarkerSize',6)
plot([-pi pi],[1/(2*pi) 1/(2*pi)],'k-')
xlabel(['\angle F_k [rad s^{-1}]'])
ylabel(['P(\angle F_k) [rad^{-1} s]'])
xmin = -pi;
xmax = pi;
ymin = 0;
ymax = 1;
axis([xmin xmax ymin ymax]);


warning on;

return;


% residue function =====================================================
function [res]=gaussfit_res(x)

global signal_pdf

fit_pdf.mu    = x(1);
fit_pdf.sigma = x(2);

NP = size(signal_pdf.Px, 1);
res= 0;
for j=1:NP
    fit_pdf.Px(j,1) = signal_pdf.Px(j,1);
    fit_pdf.Px(j,2) = 1/(sqrt(2*pi)*fit_pdf.sigma) * exp(-(fit_pdf.Px(j,1) - fit_pdf.mu)^2/(2*(fit_pdf.sigma)^2));
    if (signal_pdf.Px(j,2)~=0)
      res = res + abs(signal_pdf.Px(j,2) - fit_pdf.Px(j,2));
    end;
end;

return;

% residue function =====================================================
function [res]=xgaussfit_res(x)

global signal_pdf

fit_pdf.sigma = x(1);

NP = size(signal_pdf.Px, 1);
res= 0;
for j=1:NP
    fit_pdf.Px(j,1) = signal_pdf.Px(j,1);
    fit_pdf.Px(j,2) = fit_pdf.Px(j,1)/(fit_pdf.sigma^2) *  exp(-(fit_pdf.Px(j,1))^2/(2*(fit_pdf.sigma)^2));
    if (signal_pdf.Px(j,2)~=0)
      res = res + abs(signal_pdf.Px(j,2) - fit_pdf.Px(j,2));
    end;
end;

return;