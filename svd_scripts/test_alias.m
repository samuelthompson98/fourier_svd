% test_alias



tmin = 0e-3;
tmax = 10e-3;
dt   = 0.5e-6;
fs   = 1/dt;
t = tmin:dt:tmax;
Nt= length(t);

% fourier mode
n       = 8;
f0      = 100e+3;
w0      = f0* 2*pi;

xmd.omt(1).data           = 1 ;
xmd.omt(1).phi            = 0.1047;
xmd.omt(1).signal(:,1)    = t.';
xmd.omt(1).signal(1:Nt,2) = 0.0;

xmd.omt(2).data           = 1 ;
xmd.omt(2).phi            = 5.3047;
xmd.omt(2).signal(:,1)    = t.';
xmd.omt(2).signal(1:Nt,2) = 0.0;

xmd.omt(3).data           = 1 ;
xmd.omt(3).phi            = 6.2308;
xmd.omt(3).signal(:,1)    = t.';
xmd.omt(3).signal(1:Nt,2) = 0.0;

for i=1:Nt

    tphi = wmin * t(i);
    xmd.omt(1).signal(i,2) = cos(tphi + n * xmd.omt(1).phi)  ;
    xmd.omt(2).signal(i,2) = cos(tphi + n * xmd.omt(2).phi)  ;
    xmd.omt(3).signal(i,2) = cos(tphi + n * xmd.omt(3).phi)  ;

end
         
     
disp(['Normalization =================================']);
winl    = 128
norm    = spec_norm(winl)


disp(['Spectrum ======================================']);
XMD.omt = spec(xmd.omt, winl, norm);

tnorm = 1e-3
fnorm = 1e+3
render_kstar4(XMD.omt(1),tnorm, fnorm)

flow   = 0;
fhigh  = fs/2;
Z1     = nmode(XMD.omt,1e-3,1,flow,  fhigh)

Z1.shot= 0;


% pltn_paper(Z);
% return

[h,Zwin]  = pltn_test(Z1);
