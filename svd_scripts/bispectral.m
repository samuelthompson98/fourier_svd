
t_ind =1;
Nt = length(XMD.omt(1).t);
tvec = randperm(Nt);
Nk = min(Nt,20)

fhigh  = 40e+3;
flow   = -fhigh;
if_min = min(find(XMD.omt(1).f>flow));
if_max = max(find(XMD.omt(1).f<fhigh));
Nf     = if_max- if_min +1;
% Nf = fix(length(XMD.omt(1).f)/4)

B(1:Nf, 1:Nf) = 0.0;
norm1(1:Nf, 1:Nf) = 0.0;
norm2(1:Nf, 1:Nf) = 0.0;

for k=if_min:if_max
    for l=if_min:if_max
        fk(k,l)= XMD.omt(1).f(k);
        fl(k,l)= XMD.omt(1).f(l);
        for i = 1:Nk
             t_ind = tvec(i);
             B(k,l) = XMD.omt(1).F(k,t_ind) * XMD.omt(1).F(l,t_ind) * XMD.omt(1).F(k+l,t_ind)' + B(k,l);
             norm1(k,l) = abs(XMD.omt(1).F(k,t_ind) * XMD.omt(1).F(l,t_ind))^2 + norm1(k,l);
             norm2(k,l) = abs(XMD.omt(1).F(k+l,t_ind))^2 + norm2(k,l);
        end
    end
end

for k=1:Nf
    for l=1:Nf
        b2(k,l) = abs(B(k,l))^2/(norm1(k,l) * norm2(k,l));
        b1(k,l) = sqrt(b2(k,l));
    end
end

% figure
% contour(fk,fl, log(abs(B)))

clear cmap
Nv    = 10;
v     = 0:1/(Nv-1):1;
cmap(:,1) = 1-v.';
cmap(:,2) = 1-v.';
cmap(:,3) = 1-v.';

figure;
fs    = 14;
lw    = 1.5;
fnorm = 1e+3;
set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

[c,h]=contourf(fk/fnorm,fl/fnorm, b2,v);
colormap(cmap);
hbar = colorbar;
xlabel(['f_1 [kHz]']);
ylabel(['f_2 [kHz]']);
fbot = XMD.omt(1).f(1);
ftop = XMD.omt(1).f(Nf);
axis([fbot/fnorm ftop/fnorm fbot/fnorm ftop/fnorm]);
axes(hbar);
set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
ylabel(['b(f_1, f_2)']);

%v     = 0:1/63:1;
%map   = colormap('jet');
%b2max = max(max(b2));
%imax  = min(find(v> b2max));
%cmap  = map(1:imax,:);
%
%figure;
%[c,h]=contourf(fk,fl, b2,v);
%colormap(cmap);
%colorbar;


