


% temporal : no. of realizations
tmin = 160e-3;
tmax = 180e-3;
% tmax = min([180e-3 (tmin + winl * 0.5e-6)]);
it_min = min(find(XMD.omt(1).t>=tmin));
it_max = min(find(XMD.omt(1).t>=tmax));
t_ind  = randperm(it_max-it_min+1);
tvec   = it_min:it_max;
tvec   = tvec(t_ind);
Nt     = length(tvec);
Nk     = min(Nt,40)

% Fourier: number of frequency components
fbot   = XMD.omt(1).f(1);
ftop   = 90e+3;
fmax   = max(XMD.omt(1).f);
Nf = fix(length(XMD.omt(1).f)/fmax*ftop)

% initialize
B(1:Nf, 1:Nf) = 0.0;
norm1(1:Nf, 1:Nf) = 0.0;
norm2(1:Nf, 1:Nf) = 0.0;

for k=1:Nf
    for l=1:Nf
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
        Bn(k,l) = B(k,l)/sqrt(norm1(k,l) * norm2(k,l));
    end
end

% figure
% contour(fk,fl, log(abs(B)))


% v     = 0:1/60:1;
% map   = colormap('jet');
% b2max = max(max(b2));
% imax  = min(find(v> b2max));
% cmap  = map(1:imax,:);

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
axis([fbot/fnorm ftop/fnorm fbot/fnorm ftop/fnorm]);
axes(hbar);
set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
ylabel(['b(f_1, f_2)']);

bispec.fk = fk;
bispec.fl = fl;
bispec.Bn = Bn;