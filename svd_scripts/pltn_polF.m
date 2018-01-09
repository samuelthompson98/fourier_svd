function [hfig, X] = pltn_polF(Z, pol, XF)

% plots eigen-mode amplitudes and residue as a fn. of freq
% Matthew Hole Jan. 2002 
% plot n mode number versus frequency

fs = 14;  % font size
lw = 1.5; % line width

h0=figure;
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

% ===============================================================
h2 = subplot('Position', [0.15 0.5 0.8 0.2])
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
set(gca,'XTickLabel','');
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
Nc = length(XF);

YF = XF;

% smooth residue about frequency bins 
X = Z;

filt.gaussian = 1;
filt.arbitrary= 0;


if filt.gaussian==1

   if isfield(Z,'dtfil') 
       filt.fsigma = 0.44 / Z.dtfil *2*sqrt(2*log(2));
   else
       filt.fsigma = 1.5*1e+3;
   end
   filt.df    = Z.f(2)-Z.f(1);
   sigma_n    = filt.fsigma/filt.df;
   Nw         = Nf + (1-mod(Nf,2)); % make Nw odd
   nw         = (Nw-1)/2;
   ic         = nw+1;
   for i=1:Nw
       w(i) = 1/(sqrt(2*pi)*sigma_n)*exp(-(i-ic)^2/(2* sigma_n^2));
   end;

   Zoff.dF(1:Nf)         = 0.0;
   Zoff.a(1:Nf,:)        = 0.0;
   Zoff.dF(Nf+1:2*Nf)    = Z.dF;
   Zoff.a(Nf+1:2*Nf,:)   = Z.a;
   Zoff.dF(2*Nf+1:3*Nf)  = 0.0;
   Zoff.a(2*Nf+1:3*Nf,:) = 0.0;

   poloff.bdotB(1:Nf)           = 0.0;
   poloff.bdotB(Nf+1:2*Nf)      = pol.bdotB;
   poloff.bdotB(2*Nf+1:3*Nf)    = 0.0;
   poloff.bcrossB(1:Nf)         = 0.0;
   poloff.bcrossB(Nf+1:2*Nf)    = pol.bcrossB;
   poloff.bcrossB(2*Nf+1:3*Nf)  = 0.0;

   for j=1:Nc
      XFoff(j).F(1:Nf)          = 0.0;
      XFoff(j).F(Nf+1:2*Nf)     = XF(j).F;
      XFoff(j).F(2*Nf+1:3*Nf)   = 0;
   end
   
   for i=1:Nf
       X.f(i)       = Z.f(i);
       X.dF(i)      = Zoff.dF(Nf+i-nw:Nf+i+nw) *w.' ;
       X.a(i,:)     = abs(Zoff.a(Nf+i-nw:Nf+i+nw,:)).'*w.' ;
       X.bdotB(i)   = poloff.bdotB(Nf+i-nw:Nf+i+nw) *w.' ;
       X.bcrossB(i) = poloff.bcrossB(Nf+i-nw:Nf+i+nw) *w.' ;
       for j=1:Nc
           YF(j).F(i) = XFoff(j).F(Nf+i-nw:Nf+i+nw) *w.' ;
       end
   end;

elseif filt.arbitrary==1
    
   filt.sigma = 0;
   
   w = [0.2 0.4 0.5 1 0.5 0.4 0.2];
   w = w/sum(w)
   nw= (length(w)-1)/2
   
   Zoff.dF(1:Nf)         = 0.0;
   Zoff.a(1:Nf,:)        = 0.0;
   Zoff.dF(Nf+1:2*Nf)    = Z.dF;
   Zoff.a(Nf+1:2*Nf,:)   = Z.a;
   Zoff.dF(2*Nf+1:3*Nf)  = 0.0;
   Zoff.a(2*Nf+1:3*Nf,:) = 0.0;
   
   for i=1+nw:Nf-nw
       X.dF(i) = Zoff.dF(Nf+i-nw:Nf+i+nw) *w.' ;
       X.a(i,:)= abs(Zoff.a(Nf+i-nw:Nf+i+nw,:)).'*w.' ;
   end;
end;

X.filt = filt;

hdot =  plot(X.f, X.bdotB,'k-');
hcross= plot(X.f, X.bcrossB,'k:');
ylabel('arb.');

legend([hdot hcross],{'|\delta B \cdot B|', '|\delta B \times B|'});
% for i=1:Nf
%    semilogy(Z.f(i),abs(Z.dF(i)),residue); % plot common residure
% end;

fmin = min(X.f) + 2 * filt.fsigma;
fmax = max(X.f) - 2 * filt.fsigma;
axis([fmin fmax 0 1]);

set(gca, 'Box','on')

% ===============================================================
h1 = subplot('Position', [0.15 0.7 0.8 0.2])
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
set(gca,'XTickLabel','');
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
   % y(l(Z.n(i,j)+Nc+1),Z.n(i,j)+Nc+1) = abs(Z.a(i,j)) * 1/(2*pi*Z.f(i)*Ncoils * A);
   y(l(Z.n(i,j)+Nc+1),Z.n(i,j)+Nc+1) = abs(X.a(i,j));
   l(Z.n(i,j)+Nc+1) = l(Z.n(i,j)+Nc+1) + 1;

 end;
end;

str=[];
amin = 1; amax = 1e-15;

df = X.f(2) - X.f(1);

nmap = jet(2*Nc+1);

for n=-Nc:Nc
  if l(n+Nc+1)-1>0
    nlabel = mtype(n);
    % plot(x(1:l(n+Nc+1)-1,n+Nc+1), y(1:l(n+Nc+1)-1,n+Nc+1), nlabel);
    hbar = bar1(x(1:l(n+Nc+1)-1,n+Nc+1), y(1:l(n+Nc+1)-1,n+Nc+1), df, 1e-10,nmap(n+1+Nc,:));
    % set(h,'UserData',['n = ',num2str(n)]);
    
    amin = min([min(y(1:l(n+Nc+1)-1,n+Nc+1)) amin]);
    amax = max([max(y(1:l(n+Nc+1)-1,n+Nc+1)) amax]);
    % if n > 11 ;
    %      str = strvcat(str,['n > 11 ']);
    % elseif n < -11 ;
    %     str = strvcat(str,['n < -11 ']);
    % else 
    % end
  end;
end;

hb = colorbar('NorthOutside')
set(hb,'XTick',[0.01 0.5 0.99]); pause(0);
set(hb,'XTickLabel',{num2str(-Nc),'n=0',num2str(Nc)})

% amin = 1; amax = 1e-15;
% for i=1:NM
    % amin = min([min(abs(Z.a(:,i))) amin]);
    % amax = max([max(abs(Z.a(:,i))) amax]);
    % amin = min([min(min(y(:,:))) amin]);
    % amax = max([max(max(y(:,:))) amax]);
% end;

mmin = 1.0 * 10^(floor(log10(amin)))
mmax = 1 *  10^(ceil(log10(amax)))
axis([fmin fmax mmin mmax]);
if 10*mmin ~= mmax/10
   set(gca, 'YScale','log','Box','on','YTick',[10*mmin mmax/10])
else
   set(gca, 'YScale','log','Box','on','YTick',[mmin mmax])
end

% set(gca, 'YScale','log', 'XTickLabel', '','Box','on','YTick',[10*mmin mmax/10])
% set(gca, 'YScale','log', 'XTickLabel', '','Box','on','YTick',[0.01 0.1 1])


% ===============================================================
h3 = subplot('Position', [0.15 0.3 0.8 0.2]);
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

set(gca, 'YScale','log', 'Box','on','YTick',[ymin 0.1])
% set(gca, 'YScale','log', 'XTickLabel', '','Box','on','YTick',[ymin 0.1])

figure(h0);
% title(['#',num2str(X.shot),'@',num2str(X.t*1000),'ms, for ',num2str(1000/(X.f(2) - X.f(1))),'ms using \sigma = ',num2str(X.filt.fsigma/1000),' kHz']);

% ===============================================================
h4 = subplot('Position', [0.15 0.1 0.8 0.2]);
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
hold on;

% =====================================
fcomps = 0;
if fcomps    
    [Npdf]   = null_signal(YF)

else    % apply to mode extracted amplitude - makes little sense
    clear YF
    YF.f     = XF(1).f;
    YF.sigma = XF(1).sigma;
    YF.F     = X.a;
    [Npdf]   = null_signal(YF);
end
X.CF = Npdf.CF;

% =====================================

plot(X.f/fnorm, X.CF)

ymin = min(X.CF)
ymin = 10^(floor(log10(ymin)))
ymin = 10^(-5);
ymax = 10
axis([fmin/fnorm fmax/fnorm ymin ymax]);

set(gca, 'YScale','log', 'Box','on','YTick',[ymin ymax])

hfig = [h0 h1 h2 h3 h4 hb];

return;
