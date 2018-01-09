clear all;

% XMD 4669 =======================================================
% get data
xmd = getXMD(9429);

% fix polarity
pol_fix = 0;
if pol_fix
  xmd.omt(1).signal(:,2)  = - xmd.omt(1).signal(:,2);
  xmd.omt(2).signal(:,2)  = + xmd.omt(2).signal(:,2);
  xmd.omt(3).signal(:,2)  = - xmd.omt(3).signal(:,2);
end;

% time plot
trace(xmd.omt)

% sampling frequency
i = 1;
while ~xmd.omt(i).data
  i = i+1;
end;
fs = 1/(xmd.omt(i).signal(2,1) -  xmd.omt(i).signal(1,1))

% compute FFT
set(0,'DefaultFigureVisible','on');
XMD.omt = spec(xmd.omt, 1e+3,fs)
set(0,'DefaultFigureVisible','on');

XMD.shot = xmd.shot;

% render centre column midplane
clf;
render(XMD.omt(1));

% SVD in n at t=0.12s
Z      = nmode(XMD.omt,0.12);
Z.shot = xmd.shot;
pltn(Z)

return;

