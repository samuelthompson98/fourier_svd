
clear all

load 9425_Z.mat Z

NZ = size(Z,2);
Nf = size(Z(1).f, 1);

fs = 12;  % font size
lw = 1.5; % line width

figure; hold on;
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

% compute error bars
freq = Z(1).f;
for i=1:Nf
    for j=1:NZ
        afit(j) = abs(Z(j).a(i));
    end;
        
    apdf = form_pdf(afit);
    temp = stats(apdf);

    mag_alpha.mean(i) = temp.mu(2);
    mag_alpha.std(i)  = temp.sd(2);

end;

h = plot(freq, mag_alpha.mean, '-'); hold on;
for i=1:Nf
    plot([freq(i), freq(i)], [mag_alpha.mean(i)-mag_alpha.std(i), mag_alpha.mean(i)+mag_alpha.std(i)]);
end;
set(gca,'YScale','log','XScale','log')

% set imin just below knee at 10^3.54
imin = min(find(freq >= 10^3.54))
pfit = polyfit(log(freq(imin:Nf)), log(mag_alpha.mean(imin:Nf).'), 1);
for i=1:Nf
    mag_alpha.fit(i) = exp(pfit(2))*freq(i)^pfit(1);
end
plot(freq, mag_alpha.fit, 'r-');
set(gca,'YScale','log','XScale','log')
ylabel(['< |\alpha| > [T]']);
xlabel(['f [Hz]']);
axis([10^2 10^6 10^(-10) 10^(-5)]);

save 9425_afit.mat;

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


