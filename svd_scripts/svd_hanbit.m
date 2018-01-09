
clear all

load cc16891array2.dat


x = cc16891array2;

% construct xmd
tnorm = 0.001;
xmd.omt(1).signal(:,1) = x(:,1) * tnorm;
xmd.omt(2).signal(:,1) = x(:,1)* tnorm;
xmd.omt(3).signal(:,1) = x(:,1)* tnorm;
xmd.omt(4).signal(:,1) = x(:,1)* tnorm;

% MJH processing 15/06/07: remove mean
xmd.omt(1).signal(:,2) = x(:,2) - 0*mean(x(:,2));
xmd.omt(2).signal(:,2) = x(:,3) - 0*mean(x(:,3));
xmd.omt(3).signal(:,2) = x(:,4) - 0*mean(x(:,4));
xmd.omt(4).signal(:,2) = x(:,5) - 0*mean(x(:,5));

figure
hold on
plot(xmd.omt(1).signal(:,1), xmd.omt(1).signal(:,2),'k');
plot(xmd.omt(3).signal(:,1), xmd.omt(3).signal(:,2),'r');
plot(xmd.omt(4).signal(:,1), xmd.omt(4).signal(:,2),'b');

xmd.omt(1).data = 1;
xmd.omt(2).data = 0;
xmd.omt(3).data = 1;
xmd.omt(4).data = 1;

xmd.omt(1).phi = 0;
xmd.omt(2).phi = pi/2;
xmd.omt(3).phi = pi;
xmd.omt(4).phi = 3*pi/2;

disp(['Normalization =================================']);
winl    = 256;
winl    = 4096;
norm    = spec_norm(winl)

disp(['Spectrum ======================================']);
XMD.omt = spec(xmd.omt, winl, norm);

save 16891_XMD_bit.mat xmd XMD;

load 16891_XMD_bit.mat xmd XMD;
i_t = min(find(XMD.omt(1).t>0.205));
figure; hold on;
plot(XMD.omt(1).f, abs(XMD.omt(1).F(:,i_t)),'k');
plot(XMD.omt(3).f, abs(XMD.omt(3).F(:,i_t)),'r');
plot(XMD.omt(4).f, abs(XMD.omt(4).F(:,i_t)),'b');

tnorm = 0.001
fnorm = 1000
render_example(XMD.omt(1),tnorm, fnorm)

tmin   = 0.2050;
tmin   = 0.2010;
flow   = min(XMD.omt(1).f)
fhigh  = max(XMD.omt(1).f)
fhigh  = 30e+3;
[Z]    = nmode_hanbit(XMD.omt,tmin,2,flow,  fhigh)
Z.shot = 9429

% [h,Zwin]  = pltn_chirp(Z);

pltn_hanbit1(Z);