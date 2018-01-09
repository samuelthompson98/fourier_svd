function [hfig, X] = pltn_chirp(Z)

% plots eigen-mode amplitudes and residue as a fn. of freq
% Matthew Hole Jan. 2002 
% plot n mode number versus frequency

fs = 14;  % font size
lw = 1.5; % line width

h0=figure;
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

% ===============================================================
h2 = subplot('Position', [0.15 0.4 0.8 0.28])
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
ylabel('r');
xlabel('f [k Hz]');
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

filt.gaussian = 1;
filt.arbitrary= 0;


if filt.gaussian==1

   if isfield(Z,'dtfil') 
       filt.fsigma = 0.44 / Z.dtfil *2*sqrt(2*log(2));
   else
       filt.fsigma = 1.5*1e+3;
       filt.fsigma = 200;
       filt.fsigma = 100;
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
end;

X.filt = filt;

% w = w/sum(w)
% nw= (length(w)-1)/2
% for i=1+nw:Nf-nw
%    X.dF(i) = Z.dF(i-nw:i+nw).'*w.' ;
%    X.a(i,:)= abs(Z.a(i-nw:i+nw,:)).'*w.' ;
% end;

% plot residue
fnorm = 1e+3;
semilogy(X.f/fnorm,X.dF,residue); % plot common residure

% for i=1:Nf
%    semilogy(Z.f(i),abs(Z.dF(i)),residue); % plot common residure
% end;

fmin = (min(X.f) + 2 * filt.fsigma)/fnorm;
fmax = (max(X.f) - 2 * filt.fsigma)/fnorm;
rmin = 0.5 * 10^(floor(log10(min(X.dF))));
rmax = 2;
axis([fmin fmax rmin rmax]);

set(gca, 'YScale','log','Box','on','YTick',[0.01 0.1 1])

% set(gca, 'YScale','log','XTickLabel', '','Box','on','YTick',[0.01 0.1 1])

% ===============================================================
h1 = subplot('Position', [0.15 0.68 0.8 0.28])
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
axis([fmin*fnorm fmax*fnorm mmin mmax]);
if 10*mmin ~= mmax/10
   set(gca, 'YScale','log','Box','on','YTick',[10*mmin mmax/10])
else
   set(gca, 'YScale','log','Box','on','YTick',[mmin mmax])
end

% set(gca, 'YScale','log', 'XTickLabel', '','Box','on','YTick',[10*mmin mmax/10])
% set(gca, 'YScale','log', 'XTickLabel', '','Box','on','YTick',[0.01 0.1 1])


hfig = [h0 h1 h2 hb];



return;
