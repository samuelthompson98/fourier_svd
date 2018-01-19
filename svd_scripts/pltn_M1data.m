function [hfig, X] = pltn_M1data(Z, Znoise, varargin)

% plots eigen-mode amplitudes and residue as a fn. of freq
% Matthew Hole Jan. 2002 
% plot n mode number versus frequency

fs = 14;  % font size
lw = 1.5; % line width

h0=figure;
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

% ===============================================================
% h2 = subplot('Position', [0.15 0.4 0.8 0.28])
% set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
% set(gca,'XTickLabel','');
% ylabel('r');
% hold on;

% define residue tupe
residue.MarkerFaceColor ='k';
residue.MarkerSize      = 1;
residue.Marker          ='none';
residue.LineStyle       = '-';
residue.Color           = 'k';
residue.LineWidth       = 1.5;

amp1.Marker          ='none';
amp1.LineStyle       = '--';
amp1.Color           = 'k';
amp1.LineWidth       = 1.5;

Nf = length(Z.f);
NM = size(Z.n, 2);

% smooth residue about frequency bins 
X = Z;

if ~isempty(varargin)
    if length(varargin) == 2
        filt = varargin{2};
    end
end

if exist('filt')~=1    
    filt.gaussian = 1;
    filt.arbitrary= 0;
end

if filt.gaussian==1

   if isfield(Z,'dtfil') 
       filt.fsigma = 0.44 / Z.dtfil *2*sqrt(2*log(2));
   else
       filt.fsigma = 1.5*1e+3;
       filt.fsigma = 200;
       filt.fsigma = 100;
       filt.fsigma = 1.25*1e+3;
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
   Zoff.a(1:Nf,:)        = 0.0 * Z.a;
   Zoff.dF(Nf+1:2*Nf)    = Z.dF;
   Zoff.a(Nf+1:2*Nf,:)   = Z.a;
   Zoff.dF(2*Nf+1:3*Nf)  = 0.0;
   Zoff.a(2*Nf+1:3*Nf,:) = 0.0 * Z.a;

   for i=1:Nf
       X.dF(i) = Zoff.dF(Nf+i-nw:Nf+i+nw) *w.' ;
       X.a(i,:)= abs(Zoff.a(Nf+i-nw:Nf+i+nw,:)).'*w.' ;
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
    filt.fsigma = 0;
    X = Z;
end;

X.filt = filt;

% w = w/sum(w)
% nw= (length(w)-1)/2
% for i=1+nw:Nf-nw
%    X.dF(i) = Z.dF(i-nw:i+nw).'*w.' ;
%    X.a(i,:)= abs(Z.a(i-nw:i+nw,:)).'*w.' ;
% end;

% plot residue
% semilogy(X.f,X.dF,residue); % plot common residure

% for i=1:Nf
%    semilogy(Z.f(i),abs(Z.dF(i)),residue); % plot common residure
% end;

fmin = min(X.f) + 2 * filt.fsigma;
fmax = max(X.f) - 2 * filt.fsigma;
rmin = 0.5 * 10^(floor(log10(min(X.dF))));
rmax = 2;
% axis([fmin fmax rmin rmax]);

% set(gca, 'YScale','log','Box','on','YTick',[0.01 0.1 1])

% set(gca, 'YScale','log','XTickLabel', '','Box','on','YTick',[0.01 0.1 1])

% ===============================================================
h1 = subplot('Position', [0.15 0.5 0.8 0.38])
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
colormap(nmap);

hb = colorbar('NorthOutside');
set(hb,'XTick',[0.01 0.5 0.99]); pause(0);
set(hb,'XTickLabel',{num2str(-Nc),'n=0',num2str(Nc)})

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
h3 = subplot('Position', [0.15 0.12 0.8 0.38]);
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
hold on;

load n2f_gauss.mat pdf2_norm pdf1_norm
pdf1_norm = pdf_poly(pdf1_norm)
pdf2_norm = pdf_poly(pdf2_norm)

Nhr = 1e+4; 
dr  = 1/(Nhr-1);
pdf1_norm.hrbin = 0 : dr : 1;
pdf1_norm.hFr     = interp1(pdf1_norm.rbin, pdf1_norm.Fr, pdf1_norm.hrbin,'spline','extrap');

fnorm = 1e+3;
if NM == 1 
    X.FdF(1:Nf) = interp1(pdf1_norm.hrbin, pdf1_norm.hFr, abs(X.dF(1:Nf)),'spline','extrap');
elseif NM==2
    X.FdF(1:Nf) = interp1(pdf2_norm.rbin, pdf2_norm.Fr, abs(X.dF(1:Nf)));
end

Nha = 1e+4; 
da  = (max(pdf1_norm.abin) - min(pdf1_norm.abin))/(Nha-1);
pdf1_norm.habin   = min(pdf1_norm.abin) : da : max(pdf1_norm.abin);
pdf1_norm.hFa     = interp1(pdf1_norm.abin, pdf1_norm.Fa, pdf1_norm.habin,'spline');

if isempty(varargin)
    snr_confidence = 4;
else
    snr_confidence = varargin{1};
end 

X.a_rms       = snr_confidence * Znoise.alpha * X.f.^ Znoise.beta;
X.Fda(1:Nf,1) = 1 - interp1(pdf1_norm.habin, pdf1_norm.hFa, abs(X.a(1:Nf,1))./X.a_rms ,'v5cubic',1e-5);

tol = 1e-5;
i_erange = find((X.Fda < tol)|isnan(X.Fda));
X.Fda(i_erange,1) = tol;

hr = semilogy(X.f/fnorm, X.FdF,residue); % plot common residure
ha = semilogy(X.f/fnorm, X.Fda,amp1); % plot common residure
set(gca, 'Box','On','YScale','log')
xlabel(['f [kHz]']);
legend([hr ha],{'C_r','1-C_{\beta}'})
ylabel(['probability']);


ymin = min(X.FdF)
ymin = 10^(floor(log10(ymin)))
ymin = 1e-3;
ymax = 1;
axis([fmin/fnorm fmax/fnorm ymin ymax]);

plot([fmin/fnorm fmax/fnorm],[0.01 0.01],'r-');
set(gca, 'YScale','log', 'Box','on','YTick',[0.001 0.01 0.1 1]);

% set(gca, 'YScale','log', 'XTickLabel', '','Box','on','YTick',[ymin 0.1])

% hfig = [h0 h1 h2 h3 hb];
hfig = [h0 h1 h3 hb];

figure(h0);
% title(['#',num2str(X.shot),'@',num2str(X.t*1000),'ms, for ',num2str(1000/(X.f(2) - X.f(1))),'ms using \sigma = ',num2str(X.filt.fsigma/1000),' kHz']);


return;
