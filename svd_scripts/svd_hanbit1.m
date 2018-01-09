ymd = xmd;

% MJH processing 15/10/09: normalise to peak strength of channel 4 at 3kHz.
ymd.omt(3).signal(:,2) = 1.08e-3/1.2e-4 * xmd.omt(3).signal(:,2)
ymd.omt(1).signal(:,2) = 1.08e-3/3.6e-4 * xmd.omt(1).signal(:,2)

figure
hold on
plot(ymd.omt(1).signal(:,1), ymd.omt(1).signal(:,2),'k');
plot(ymd.omt(3).signal(:,1), ymd.omt(3).signal(:,2),'r');
plot(ymd.omt(4).signal(:,1), ymd.omt(4).signal(:,2),'b');


disp(['Spectrum ======================================']);
YMD.omt(1) = spec(ymd.omt(1), winl, norm);
YMD.omt(3) = spec(ymd.omt(3), winl, norm);
YMD.omt(2) = XMD.omt(2);
YMD.omt(4) = XMD.omt(4);
save 16891_XMD_bit1.mat xmd ymd XMD YMD ;

load 16891_XMD_bit1.mat xmd ymd XMD YMD

i_t = min(find(YMD.omt(1).t>0.205));
figure; hold on;
plot(YMD.omt(1).f, abs(YMD.omt(1).F(:,i_t)),'k');
plot(YMD.omt(3).f, abs(YMD.omt(3).F(:,i_t)),'r');
plot(YMD.omt(4).f, abs(YMD.omt(4).F(:,i_t)),'b');

tmin   = 0.2030;
flow   = min(YMD.omt(1).f)
fhigh  = max(YMD.omt(1).f)
fhigh  = 30e+3;
[Z2]    = nmode_hanbit(YMD.omt,tmin,1,flow,  fhigh)
Z2.shot = 9429

% [h,Zwin]  = pltn_chirp(Z);

pltn_hanbit1(Z2);
