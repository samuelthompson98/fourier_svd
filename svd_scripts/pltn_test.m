function [hfig, X] = pltn_test(Z)

% plots eigen-mode amplitudes and residue as a fn. of freq
% Matthew Hole Jan. 2002 
% plot n mode number versus frequency

fs = 14;  % font size
lw = 1.5; % line width

h0=figure;
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

% ===============================================================
h2 = subplot(2,1,2)
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
h1 = subplot(2,1,1)
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
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
    % plot(x(1:l(n+Nc+1)-1,n+Nc+1), y(1:l(n+Nc+1)-1,n+Nc+1), nlabel);
    hbar = bar1(x(1:l(n+Nc+1)-1,n+Nc+1), y(1:l(n+Nc+1)-1,n+Nc+1), df, 1e-16,nmap(n+1+Nc,:));
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

axis([fmin fmax amin amax]);

hb = colorbar('horiz')
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

hfig = [h0 h1 h2 hb];

figure(h0);
title(['t = ',num2str(Z.t)])

return;
