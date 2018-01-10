function [hfig, X] = pltn_hanbit2(Z)

% plots eigen-mode amplitudes and residue as a fn. of freq
% Matthew Hole Jan. 2002 
% plot n mode number versus frequency

fs = 14;  % font size
lw = 1.5; % line width

h0=figure;
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

% ===============================================================
hsub(2) = subplot('Position',[0.15 0.15 0.7 0.35])
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
ylabel('r');
hold on;

% define residue tupe
residue.MarkerFaceColor ='k';
residue.MarkerSize      = 1;
residue.Marker          ='none';
residue.LineStyle       = '-';
residue.Color           = 'k';
residue.LineWidth       = 1.5;

Nf = length(Z.f);
NM = size(Z.n, 2);

% smooth residue about frequency bins 
X = Z;


% plot residue
semilogy(X.f,X.dF,residue); % plot common residure


fmin = min(X.f);
fmax = max(X.f);
rmin = 0.5 * 10^(floor(log10(min(X.dF))));
rmax = 2;
axis([fmin fmax rmin rmax]);

set(gca, 'YScale','log','Box','on','YTick',[0.01 0.1 1])

% set(gca, 'YScale','log','XTickLabel', '','Box','on','YTick',[0.01 0.1 1])

% ===============================================================
hsub(1) = subplot('Position',[0.15 0.5 0.7 0.5])
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
ylabel('|\delta B| [T Hz^{-1}]');
hold on;

% plot the  amplitude of the mode(s)
Nc=Z.Nc; l(1:2*Nc+1,1)=1;

% Values of OMAHA taken from stray capacitance paper 
Ncoils = 30;
A      = pi* (10.7e-3)^2;
for i=1:Nf
 for j=1:NM
 
   x(l(Z.n(i,j)+Nc+1),Z.n(i,j)+Nc+1) = X.f(i);
   y(l(Z.n(i,j)+Nc+1),Z.n(i,j)+Nc+1) = abs(X.a(i,j));
   l(Z.n(i,j)+Nc+1) = l(Z.n(i,j)+Nc+1) + 1;

 end;
end;

str=[];
amin = 1; amax = 1e-15;

df = X.f(2) - X.f(1);

nmap = jet(2*Nc+1);

for i=1:Nf
    for j=1:NM
    %    if l(n+Nc+1)-1>0
    % nlabel = mtype(n);
    % plot(x(1:l(n+Nc+1)-1,n+Nc+1), y(1:l(n+Nc+1)-1,n+Nc+1), nlabel);

        hbar = plot(X.f(i), abs(X.a(i,j)), 'Marker','o','MarkerFaceColor',nmap(Nc + 1 + Z.n(i,j),:),'MarkerSize',8)
    
    % hbar = bar1(x(1:l(n+Nc+1)-1,n+Nc+1), y(1:l(n+Nc+1)-1,n+Nc+1), df, 1e-10,nmap(n+1+Nc,:));
    % set(h,'UserData',['n = ',num2str(n)]);
    
    % amin = min([min(y(1:l(n+Nc+1)-1,n+Nc+1)) amin]);
    % amax = max([max(y(1:l(n+Nc+1)-1,n+Nc+1)) amax]);
    % if n > 11 ;
    %      str = strvcat(str,['n > 11 ']);
    % elseif n < -11 ;
    %     str = strvcat(str,['n < -11 ']);
    % else 
    % end
  end;
end;
colormap(nmap)

hb = colorbar('NorthOutside');
set(hb,'XTick',[1 Nc+1 2*Nc+1]); 
set(hb,'XTickLabel',{num2str(-Nc),'n=0',num2str(Nc)})

% amin = 1; amax = 1e-15;
% for i=1:NM
    % amin = min([min(abs(Z.a(:,i))) amin]);
    % amax = max([max(abs(Z.a(:,i))) amax]);
    % amin = min([min(min(y(:,:))) amin]);
    % amax = max([max(max(y(:,:))) amax]);
% end;

amin = min(min(abs(Z.a)))
amax = max(max(abs(Z.a)))

mmin = 1.0 * 10^(floor(log10(amin)))
mmax = 1 *  10^(ceil(log10(amax)))
axis([fmin fmax mmin mmax]);

set(gca, 'YScale','linear','Box','on','YTick',[mmin mmax])
set(hsub(1),'XTick',[])
%if 10*mmin ~= mmax/10
%   set(gca, 'YScale','log','Box','on','YTick',[10*mmin mmax/10])
%else
%   set(gca, 'YScale','log','Box','on','YTick',[mmin mmax])
%end

% set(gca, 'YScale','log', 'XTickLabel', '','Box','on','YTick',[10*mmin mmax/10])
% set(gca, 'YScale','log', 'XTickLabel', '','Box','on','YTick',[0.01 0.1 1])
linkaxes(hsub,'x');

hfig = [h0 hsub];

return


% ===============================================================
h3 = subplot('Position', [0.15 0.12 0.8 0.28]);
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
hold on;

load noise_gauss.mat pdf1_gauss pdf2_gauss

pdf1_gauss = pdf_poly(pdf1_gauss)
pdf2_gauss = pdf_poly(pdf2_gauss)

Nhr = 1e+4; 
dr  = 1/(Nhr-1);
pdf1_gauss.hrbin = 0 : dr : 1;
pdf1_gauss.hFr     = interp1(pdf1_gauss.rbin, pdf1_gauss.Fr, pdf1_gauss.hrbin,'spline','extrap');

fnorm = 1e+3;
if NM == 1 
    X.FdF(1:Nf) = interp1(pdf1_gauss.hrbin, pdf1_gauss.hFr, abs(X.dF(1:Nf)),'spline','extrap');
elseif NM==2
    X.FdF(1:Nf) = interp1(pdf2_gauss.rbin, pdf2_gauss.Fr, abs(X.dF(1:Nf)));
end

semilogy(X.f/fnorm, X.FdF,residue); % plot common residure
set(gca, 'Box','On','YScale','log')
xlabel(['f [kHz]']);
ylabel(['F(r)']);

ymin = min(X.FdF)
ymin = 10^(floor(log10(ymin)))
ymax = 1
axis([fmin/fnorm fmax/fnorm ymin ymax]);

set(gca, 'YScale','log', 'Box','on','YTick',[ymin 1]);
% set(gca, 'YScale','log', 'XTickLabel', '','Box','on','YTick',[ymin 0.1])

hfig = [h0 h1 h2 h3 hb];

figure(h0);
title(['#',num2str(X.shot),'@',num2str(X.t*1000),'ms, for ',num2str(1000/(X.f(2) - X.f(1))),'ms using \sigma = ',num2str(X.filt.fsigma/1000),' kHz']);


return;