
clear all

load 9425_YMD.mat YMD

XMD = YMD;
% perform fitting for coil 1 only

NZ = size(XMD.omt(1).F,2);
Nf = size(XMD.omt(1).F,1);

figure; hold off;

load  MC_9425_pdfs.mat data_out spectra_out fit_pdf;
i_freq = 2;

% compute error bars
freq_show = 0;
freq = XMD.omt(1).f;
for i=1:Nf
    for j=1:NZ
        Ffit(j) = abs(XMD.omt(1).F(i,j));
    end;
    
    Fpdf = form_pdf(Ffit);
    temp = stats(Fpdf);

    % mag_F.mean(i) = mean(Ffit);
    % mag_F.std(i)  = std(Ffit);
    
    mag_F.mean(i) = temp.mu(2);
    mag_F.std(i)  = temp.sd(2);
    Fpdf(:,2)     = Fpdf(:,2)/temp.int(2);

    clear temp
    Spdf(:,1) = spectra_out.IPFmag(i,:,2);
    Spdf(:,2) = spectra_out.IPFmag(i,:,3);
    temps     = stats(Spdf);    
    mag_s.mean(i) = temps.mu(2);
    mag_s.std(i)  = temps.sd(2);
 
    if freq_show
        plot(Fpdf(:,1), Fpdf(:,2)); hold on;
        % plot(spectra_out.IPFmag(i_freq,:,2),  spectra_out.IPFmag(i_freq,:,3),'ko','MarkerSize',3);
        plot(spectra_out.IPFmag(i,:,2),  spectra_out.IPFmag(i,:,3),'ko','MarkerSize',3);
        plot([mag_F.mean(i), mag_F.mean(i)], [min(Fpdf(:,2)), max(Fpdf(:,2))],'r'); 
        plot([mag_s.mean(i), mag_s.mean(i)], [min(Spdf(:,2)), max(Spdf(:,2))],'g'); 
        title(['f = ',num2str(freq(i))]);
        pause; hold off;
    end 
end;

h = plot(freq, mag_F.mean, '-'); hold on;
for i=1:Nf
    plot([freq(i), freq(i)], [mag_F.mean(i)-mag_F.std(i), mag_F.mean(i)+mag_F.std(i)]);
end;

% set imin just below knee at 10^3.54
imin = min(find(freq >= 10^3.54))
pfit = polyfit(log(freq(imin:Nf)), log(mag_F.mean(imin:Nf)), 1);
for i=1:Nf
    mag_F.fit(i) = exp(pfit(2))*freq(i)^pfit(1);
end
plot(freq, mag_F.fit, 'r-');
set(gca,'YScale','log','XScale','log')
xlabel(['|F_1|']);
axis([10^2 10^6 10^(-10) 10^(-5)]);

save 9425_Ffit.mat

return;

mean(alpha);
std(alpha);

figure; hold on;
for i=1:NZ
    % for j=1:Nf
        plot(Z(i).f, abs(Z(i).a),'.'); hold on;
    % end;
    set(gca,'YScale','log','XScale','log')
end;


return;
pltn_paper(Z);



fs = 14;  % font size
lw = 1.5; % line width

hold on;
h1 = subplot('Position', [0.15 0.68 0.8 0.28]); hold on;
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

text(350e+3,1e-6,'n=8','FontSize',fs);
text(350e+3,1e-7,'n=13','FontSize',fs);
