
% figure 2
% Perform SVD decomposition, and return n mode analysis

clear all
load ../SVD4/9429_xmd.mat
%load 9429_xmd_17_06_07.mat

% MJH processing 15/06/07: remove mean
xmd.omt(1).signal(:,2) = xmd.omt(1).signal(:,2) - mean(xmd.omt(1).signal(:,2));
xmd.omt(2).signal(:,2) = xmd.omt(2).signal(:,2) - mean(xmd.omt(2).signal(:,2));
xmd.omt(3).signal(:,2) = xmd.omt(3).signal(:,2) - mean(xmd.omt(3).signal(:,2));


disp(['Normalization =================================']);
winl    = 2048
% winl    = 4096
% winl    = 2048
norm    = spec_norm(winl)


disp(['Spectrum ======================================']);
XMD.omt(1) = spec(xmd.omt(1), winl, norm);

toff   = min(xmd.omt(1).signal(:,1));
% disp(['computation time = ', num2str(0.069+toff)]);
% [Z]    = nmode(XMD.omt,0.069+toff,1,500,100e+3)

tnorm = 1e-3
fnorm = 1e+3
render_example(XMD.omt(1),tnorm, fnorm)


tmin = 160e-3;
tmax = min([180e-3 (tmin + winl * 0.5e-6)]);
it_min = min(find(XMD.omt(1).t>tmin));
it_max = min(find(XMD.omt(1).t>tmax));
Nf     = size(XMD.omt(1).f,2)
for i=1:Nf
    XMD.omt(1).Fmean(i) = mean(abs(XMD.omt(1).F(i,it_min:it_max)));
end;
figure
plot(XMD.omt(1).f, XMD.omt(1).Fmean);

% find NTM peaks (in frequency) and amplitudes
if_min = min(find(XMD.omt(1).f >10e+3)); 
if_max = min(find(XMD.omt(1).f >30e+3)); 
[NTM.A(1), if_pk] = max(XMD.omt(1).Fmean(if_min:if_max));
NTM.f(1) = XMD.omt(1).f(if_pk+ if_min - 1);

if_min = min(find(XMD.omt(1).f >20e+3)); 
if_max = min(find(XMD.omt(1).f >40e+3)); 
[NTM.A(2), if_pk] = max(XMD.omt(1).Fmean(if_min:if_max));
NTM.f(2) = XMD.omt(1).f(if_pk+ if_min -1 );

if_min = min(find(XMD.omt(1).f >40e+3)); 
if_max = min(find(XMD.omt(1).f >60e+3)); 
[NTM.A(3), if_pk] = max(XMD.omt(1).Fmean(if_min:if_max));
NTM.f(3) = XMD.omt(1).f(if_pk+ if_min -1 );

if_min = min(find(XMD.omt(1).f >60e+3)); 
if_max = min(find(XMD.omt(1).f >80e+3)); 
[NTM.A(4), if_pk] = max(XMD.omt(1).Fmean(if_min:if_max));
NTM.f(4) = XMD.omt(1).f(if_pk+ if_min-1);

if_min = min(find(XMD.omt(1).f >80e+3)); 
if_max = min(find(XMD.omt(1).f >100e+3)); 
[NTM.A(5), if_pk] = max(XMD.omt(1).Fmean(if_min:if_max));
NTM.f(5) = XMD.omt(1).f(if_pk+ if_min-1);

[NTM.noise, if_noise] = min(XMD.omt(1).Fmean(if_min:if_max));
NTM.fnoise = XMD.omt(1).f(if_noise + if_min - 1);

% save 9429_XMD_NTM.mat XMD NTM;

bispectral_data

f1  = NTM.f(1);
f2  = 2*f1;

plot_biphase(bispec, f1/2, 3*f1/2)
plot_biphase(bispec, f2/2, 3*f2/2)


return

ifk_max = max(find(bispec.fk(:,1)<1.5*f1));
ifl_max = max(find(bispec.fl(1,:)<1.5*f1));

[junk, ifk_vec]  = max(abs(bispec.Bn(1:ifk_max,1:ifl_max)));
[junk, ifk_posn] = max(max(abs(bispec.Bn(1:ifk_max,1:ifl_max))));

ifk = ifk_vec(ifk_posn);

% ifk = ifk+1;
ifl = 2*ifk;

f1  = bispec.fk(ifk,1);
f2  = 2*f1;

figure
fs = 14;
lw = 1.5;
set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

subplot(2,1,1); hold on;
set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

plot(bispec.fl(1,:), abs(bispec.Bn(ifk-1,:)),'b')
plot(bispec.fl(1,:), abs(bispec.Bn(ifk,:)),'b')
plot(bispec.fl(1,:), abs(bispec.Bn(ifk+1,:)),'b')

plot([f1 2*f1 3*f1 4*f1], [abs(bispec.Bn(ifk,ifk))  abs(bispec.Bn(ifk,2*ifk))  abs(bispec.Bn(ifk,3*ifk))  abs(bispec.Bn(ifk,4*ifk))] ,'b.', 'MarkerSize', 12)

plot(bispec.fk(:,1), abs(bispec.Bn(:,ifl-1)),'r')
plot(bispec.fk(:,1), abs(bispec.Bn(:,ifl)),'r')
plot(bispec.fk(:,1), abs(bispec.Bn(:,ifl+1)),'r')
plot([f2 2*f2], [abs(bispec.Bn(ifl,ifl))  abs(bispec.Bn(2*ifl,ifl))] ,'r.', 'MarkerSize', 12)

ylabel(['|B|']);

subplot(2,1,2); hold on;
set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
phl(1,:) = angle(bispec.Bn(ifk-1,:))/pi * 180;
phl(2,:) = angle(bispec.Bn(ifk,:))/pi * 180;
phl(3,:) = angle(bispec.Bn(ifk+1,:))/pi * 180;

phk(1,:) = (angle(bispec.Bn(:,ifl-1))/pi * 180).';
phk(2,:) = (angle(bispec.Bn(:,ifl))/pi * 180).';
phk(3,:) = (angle(bispec.Bn(:,ifl+1))/pi * 180).';

Nph = length(phl);
ph_jump = 180;
for i=1:Nph
    for j=1:3
        while phl(j,i)<-ph_jump         phl(j,i) = phl(j,i) + 2*ph_jump;    end
        while phl(j,i)>+ph_jump         phl(j,i) = phl(j,i) - 2*ph_jump;    end    
        while phk(j,i)<-ph_jump         phk(j,i) = phk(j,i) + 2*ph_jump;    end
        while phk(j,i)>+ph_jump         phk(j,i) = phk(j,i) - 2*ph_jump;    end    
    end    
end
plot(bispec.fl(1,:), phl(1,:),'b')
plot(bispec.fl(1,:), phl(2,:),'b')
plot(bispec.fl(1,:), phl(3,:),'b')
plot([f1 2*f1 3*f1 4*f1], [phl(2,ifk) phl(2,2*ifk) phl(2,3*ifk) phl(2, 4*ifk)],'b.', 'MarkerSize', 12)

plot(bispec.fk(:,1), phk(1,:),'r')
plot(bispec.fk(:,1), phk(2,:),'r')
plot(bispec.fk(:,1), phk(3,:),'r')
plot([f2 2*f2], [phk(2,ifl) phk(2, 2*ifl)],'r.', 'MarkerSize', 12)
% f1 = min(bispec.fl(1,:))
% f2 = max(bispec.fl(1,:))


xlabel(['f [Hz]']);
ylabel(['<B']);
