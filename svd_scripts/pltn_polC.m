function [hfig, X] = pltn_polC(Z, pol, varargin)
clear global signal
global signal

% plots eigen-mode amplitudes and residue as a fn. of freq
% Matthew Hole Jan. 2002 
% plot n mode number versus frequency



Nf = length(Z.f);
NM = size(Z.n, 2);

% smooth residue about frequency bins 
X = Z;

filt.gaussian = 1;
filt.arbitrary= 0;
filt.fsigma = 0

if filt.gaussian==1

   if isfield(Z,'dtfil') 
       filt.fsigma = 0.44 / Z.dtfil *2*sqrt(2*log(2));
   else
       filt.fsigma = 1.5*1e+3;
   end
   if ~isempty(varargin)
       filt.fsigma = varargin{1};
   end;
   filt.df    = Z.f(2)-Z.f(1);
   sigma_n    = filt.fsigma/filt.df;
   Nw         = Nf + (1-mod(Nf,2)); % make Nw odd
   nw         = (Nw-1)/2;
   ic         = nw+1;
   for i=1:Nw
       w(i) = 1/(sqrt(2*pi)*sigma_n)*exp(-(i-ic)^2/(2* sigma_n^2));
   end;
   w = w/sum(w)
   nw= (length(w)-1)/2

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

  for i=1:Nf
       X.f(i)       = Z.f(i);
       X.dF(i)      = Zoff.dF(Nf+i-nw:Nf+i+nw) *w.' ;
       X.a(i,:)     = abs(Zoff.a(Nf+i-nw:Nf+i+nw,:)).'*w.' ;
       X.bdotB(i)   = poloff.bdotB(Nf+i-nw:Nf+i+nw) *w.' ;
       X.bcrossB(i) = poloff.bcrossB(Nf+i-nw:Nf+i+nw) *w.' ;
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

else
   X.bdotB  = pol.bdotB.' ;
   X.bcrossB= pol.bcrossB.';
   
end;

X.filt = filt;

% ===============================================================
fs = 14;  % font size
blw= 1.5; % box line width
llw= 1.0; % line width

h0=figure;
set(gca,'FontSize', fs, 'LineWidth',blw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;


% ===============================================================
h1 = subplot('Position', [0.15 0.65 0.8 0.3])
set(gca,'FontSize', fs, 'LineWidth',blw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
set(gca,'XTickLabel','');
ylabel('|\delta B| [T Hz^{-1}]');
hold on;

% plot the  amplitude of the mode(s)
Nc=Z.Nc; l(1:2*Nc+1,1)=1;

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

for n=-Nc:Nc
  if l(n+Nc+1)-1>0

    nlabel = mtype(n);
    hbar = bar1(x(1:l(n+Nc+1)-1,n+Nc+1), y(1:l(n+Nc+1)-1,n+Nc+1), df, 1e-10,nmap(n+1+Nc,:));
    
    amin = min([min(y(1:l(n+Nc+1)-1,n+Nc+1)) amin]);
    amax = max([max(y(1:l(n+Nc+1)-1,n+Nc+1)) amax]);
  end;
end;


% fit Gaussian to peak MJH 18/04/07
% fit width = 5kHz either side of peak 
% ===============================================================
% global signal
ffit = 0;

if ffit 

sigma   = 5e+3;
[a,i_pk]= max(abs(X.a))
df      = X.f(2) - X.f(1);
i_min   = min(find(X.f > X.f(i_pk) - 2*sigma));
i_max   = max(find(X.f < X.f(i_pk) + 2*sigma));
Nwfit   = i_max-i_min+1;

x(1) = X.f(i_pk);
x(2) = sigma/4;
signal.mag = abs(X.a(i_pk));
x(3) = signal.mag;

for i=1:Nwfit
    signal.f(i) = X.f(i+i_min);
    signal.w(i) = abs(X.a(i+i_min));
end;

gaussfit_res(x)

OPTIONS = OPTIMSET('MaxIter', 100, 'MaxFunEvals', 1e+5, 'TolFun', 1e-6,'Display', 'iter');  
x = fminsearch(@gaussfit_res, x, OPTIONS)

for i=1:Nwfit
   signal.wtrial(i) = x(3)*exp(-(signal.f(i)-x(1))^2/(2* x(2)^2));
end;
plot(signal.f, signal.wtrial,'k-'); hold on;
% plot(signal.f, signal.w,'k-');
text(x(1), 2*x(3),['mu = ',num2str(x(1)),', sigma = ',num2str(x(2))]);

end

% ===============================================================



hb = colorbar('NorthOutside')
set(hb,'XTick',[0.01 0.5 0.99]); pause(0);
set(hb,'XTickLabel',{num2str(-Nc),'n=0',num2str(Nc)})

fmin = min(X.f) + 2 * filt.fsigma;
fmax = max(X.f) - 2 * filt.fsigma;
mmin = 1.0 * 10^(floor(log10(amin)))
mmax = 1 *  10^(ceil(log10(amax)))
axis([fmin fmax mmin mmax]);
if 10*mmin ~= mmax/10
   set(gca, 'YScale','log','Box','on','YTick',[10*mmin mmax/10])
else
   set(gca, 'YScale','log','Box','on','YTick',[mmin mmax])
end

% ===============================================================
h2 = subplot('Position', [0.15 0.35 0.8 0.3]);
set(gca,'FontSize', fs, 'LineWidth',blw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
hold on;

% MJH 18/04/07 load noise_gauss.mat pdf1_gauss
% MJH 09/05/2013 - halt load
load ../MC_svd/n100k_gauss.mat pdf1_gauss
% load ../MC_svd/n1_gauss_10k.mat pdf1_gauss

pdf1_gauss = pdf_poly(pdf1_gauss)

Nhr = 1e+4; 
dr  = 1/(Nhr-1);
pdf1_gauss.hrbin = 0 : dr : 1;
pdf1_gauss.hFr     = interp1(pdf1_gauss.rbin, pdf1_gauss.Fr, pdf1_gauss.hrbin,'spline','extrap');

fnorm = 1e+3;

X.FdF(1:Nf) = interp1(pdf1_gauss.hrbin, pdf1_gauss.hFr, abs(X.dF(1:Nf)),'spline','extrap');

% plot common residue to mode fit
hs1  = plot(X.f/fnorm, X.FdF/(2*Nc+1),'k-');

% MJH 18/04/07 load n1k_gauss.mat pdf1_gauss
load ../MC_svd/n100k_gauss.mat pdf1_gauss

junk.Pa(:,1) = pdf1_gauss.abin;
junk.Pa(:,2) = pdf1_gauss.Pa;
pdf1_gauss.Pa_stats = stats(junk.Pa);
pdf1_gauss.amean    = pdf1_gauss.Pa_stats.mu(2);
pdf1_gauss.abin     = pdf1_gauss.abin/pdf1_gauss.amean;

load ../MC_svd/Bnoise_rms.mat Bnoise
X.a_rms = interp1(Bnoise.f, Bnoise.a_rms,X.f, 'linear','extrap');

% shift centre
ymin = 1e-3;
ymax = 1.2;
for i=1:Nf
    X.Fa(i) = 1 - interp1(pdf1_gauss.abin * X.a_rms(i), pdf1_gauss.Fa, abs(X.a(i)), 'linear',1-ymin/2);
    if (X.Fa(i)==0) X.Fa(i) = ymin/2; end;
end

% plot probability that amplitude is noise
hs2 = plot(X.f/fnorm, X.Fa,'k--','LineWidth',llw)

plot([fmin/fnorm fmax/fnorm], [0.01 0.01],'r-','LineWidth',llw);
axis([fmin/fnorm fmax/fnorm ymin ymax]);
ylabel(['probability']);
legend([hs1 hs2],{'C_r','1-C_{\beta}'});
set(gca, 'YScale','log', 'Box','on','YTick',[ymin 1])
set(gca,'XTickLabel','');

% ===============================================================
h3 = subplot('Position', [0.15 0.05 0.8 0.3])
set(gca,'FontSize', fs, 'LineWidth',blw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
hold on;

hdot =  plot(X.f/fnorm, X.bdotB,'k-','LineWidth',llw);
hcross= plot(X.f/fnorm, X.bcrossB,'k--','LineWidth',llw);

legend([hdot hcross],{'|\delta B \cdot B|', '|\delta B \times B|'});
axis([fmin/fnorm fmax/fnorm 0 1.2]);
ylabel('polarization');
xlabel('f [kHz]');
set(gca, 'Box','on')
set(gca, 'YScale','linear', 'Box','on','YTick',[0 1])

hfig = [h0 h1 h2 h3 hb];

return;


% residue function =====================================================
function [res]=gaussfit_res(x)

global signal

Nw = size(signal.f, 2);
res= 0;
for i=1:Nw
    signal.wtrial(i) = x(3)*exp(-(signal.f(i)-x(1))^2/(2* x(2)^2));
    res = res + abs(signal.wtrial(i)- signal.w(i))^2;
end;

return;
