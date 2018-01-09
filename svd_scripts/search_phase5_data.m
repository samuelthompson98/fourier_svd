
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
winl    = 256;
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


tmin = 220e-3;
tmax = 221e-3;
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

if_min = min(find(XMD.omt(1).f >280e+3)); 
if_max = max(find(XMD.omt(1).f <300e+3)); 
[CAE.A(1), if_pk] = max(XMD.omt(1).Fmean(if_min:if_max));
CAE.f(1) = XMD.omt(1).f(if_pk+ if_min - 1);

if_min = min(find(XMD.omt(1).f >260e+3)); 
if_max = max(find(XMD.omt(1).f <280e+3)); 
[CAE.A(2), if_pk] = max(XMD.omt(1).Fmean(if_min:if_max));
CAE.f(2) = XMD.omt(1).f(if_pk+ if_min - 1);

if_min = min(find(XMD.omt(1).f >300e+3)); 
if_max = max(find(XMD.omt(1).f <320e+3)); 
[CAE.A(3), if_pk] = max(XMD.omt(1).Fmean(if_min:if_max));
CAE.f(3) = XMD.omt(1).f(if_pk+ if_min - 1);

if_min = min(find(XMD.omt(1).f >320e+3)); 
if_max = max(find(XMD.omt(1).f <340e+3)); 
[CAE.A(4), if_pk] = max(XMD.omt(1).Fmean(if_min:if_max));
CAE.f(4) = XMD.omt(1).f(if_pk+ if_min - 1);

save 9429_XMD_CAE.mat XMD NTM CAE;