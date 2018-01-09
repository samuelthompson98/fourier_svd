clear all;

% XMB 4669 =======================================================
% get data
xmb = getXMC(8302);

% remove bad data
xmb.cc_mt_2(1).data   =0;
xmb.cc_mt_2(4).data   =0;
xmb.cc_mt_2(12).data  =0;

% fix polarity
pol_fix = 0;
if pol_fix

xmb.cc_mt_2(1).signal(:,2)  = - xmb.cc_mt_2(1).signal(:,2);
xmb.cc_mt_2(2).signal(:,2)  = + xmb.cc_mt_2(2).signal(:,2);
xmb.cc_mt_2(3).signal(:,2)  = - xmb.cc_mt_2(3).signal(:,2);
xmb.cc_mt_2(4).signal(:,2)  = - xmb.cc_mt_2(4).signal(:,2);
xmb.cc_mt_2(5).signal(:,2)  = + xmb.cc_mt_2(5).signal(:,2);
xmb.cc_mt_2(6).signal(:,2)  = - xmb.cc_mt_2(6).signal(:,2);
xmb.cc_mt_2(7).signal(:,2)  = - xmb.cc_mt_2(7).signal(:,2);
xmb.cc_mt_2(8).signal(:,2)  = - xmb.cc_mt_2(8).signal(:,2);
xmb.cc_mt_2(9).signal(:,2)  = - xmb.cc_mt_2(9).signal(:,2);
xmb.cc_mt_2(10).signal(:,2) = - xmb.cc_mt_2(10).signal(:,2);
xmb.cc_mt_2(11).signal(:,2) = - xmb.cc_mt_2(11).signal(:,2);
xmb.cc_mt_2(12).signal(:,2) = - xmb.cc_mt_2(12).signal(:,2);
end;

% time plot
trace(xmb.cc_mt_2)

% sampling frequency
i = 1;
while ~xmb.cc_mt_2(i).data
  i = i+1;
end;
fs = 1/(xmb.cc_mt_2(i).signal(2,1) -  xmb.cc_mt_2(i).signal(1,1))

% compute FFT
set(0,'DefaultFigureVisible','off');
XMB.cc_mt_2 = spec(xmb.cc_mt_2, 1e+3,fs)
set(0,'DefaultFigureVisible','on');

XMB.shot = xmb.shot;

% render centre column midplane
clf;
render(XMB.cc_mt_2(5));

% SVD in n at t=0.12s
Z      = nmode(XMB.cc_mt_2,0.12);
Z.shot = xmb.shot;
pltn(Z)

return;

