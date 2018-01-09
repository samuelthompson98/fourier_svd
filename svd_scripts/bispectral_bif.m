
function [bispec] = bispectral_bif(XMD)

t_ind =1;
Nt = length(XMD.omt(1).t);
tvec = randperm(Nt);
Nk = min(Nt,60)

fhigh  = 40e+3;
flow   = -fhigh;
if_min = max(find(XMD.omt(1).f<flow));
if_max = min(find(XMD.omt(1).f>fhigh));
if_cen = find(XMD.omt(1).f == 0);
Nf     = if_max- if_min +1;
% Nf = fix(length(XMD.omt(1).f)/4)

B(1:Nf, 1:Nf) = 0.0;
norm1(1:Nf, 1:Nf) = 0.0;
norm2(1:Nf, 1:Nf) = 0.0;

for k=if_min:if_max
    for l=if_min:if_max
        fk(k-if_min+1,l-if_min+1)= XMD.omt(1).f(k);
        fl(k-if_min+1,l-if_min+1)= XMD.omt(1).f(l);
        for i = 1:Nk
             t_ind = tvec(i);
             B(k-if_min+1,l-if_min+1)     = XMD.omt(1).F(k,t_ind) * XMD.omt(1).F(l,t_ind) * XMD.omt(1).F(k-if_cen + l-if_cen + if_cen,t_ind)' + B(k-if_min+1,l-if_min+1);
             norm1(k-if_min+1,l-if_min+1) = abs(XMD.omt(1).F(k,t_ind) * XMD.omt(1).F(l,t_ind))^2 + norm1(k-if_min+1,l-if_min+1);
             norm2(k-if_min+1,l-if_min+1) = abs(XMD.omt(1).F(k-if_cen + l-if_cen + if_cen,t_ind))^2 + norm2(k-if_min+1,l-if_min+1);
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

% map b2 to zero in redundant region
% l <= k
% l <= -k
lc = find(fl(1,:) == 0)
kc = find(fk(:,1) == 0)

for k=1:Nf
    for l=1:Nf
        if ((l-lc<k-kc)|(l-lc<-(k-kc)))
            b2(k,l) = 0;
            b1(k,l) = 0.0;
            Bn(k,l) = 0.0;
        end    
    end
end



% figure
% contour(fk,fl, log(abs(B)))

clear cmap
vmax  = max(max(b2));
Nv    = max([fix(10 * vmax) 10]);
v     = 0:vmax/(Nv-1):vmax;
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

hold on;
ulimfk = 0:fhigh/100:fhigh;
ulimfl = ulimfk;
dlimfk = 0:-fhigh/100:-fhigh;
dlimfl = -dlimfk;

plot(ulimfk, ulimfl,'k-');
plot(dlimfk, dlimfl,'k-');
daspect([1 1 1]);

hbar = colorbar;
xlabel(['f_1 [kHz]']);
ylabel(['f_2 [kHz]']);
fbot = flow
ftop = fhigh
axis([fbot/fnorm ftop/fnorm 0/fnorm ftop/fnorm]);
axes(hbar);
set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
ylabel(['b(f_1, f_2)']);


bispec.Bn = Bn;
bispec.b1 = b1;
bispec.b2 = b2;
bispec.fk = fk;
bispec.fl = fl;

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

return

