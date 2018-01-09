clear all;

% XMB 4669 =======================================================
% get data
xmb = getXMB(4669);

% remove bad data
xmb.cc_mt_2(1).data   =0;
xmb.cc_mt_2(4).data   =0;
xmb.cc_mt_2(12).data  =0;

% fix polarity
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

% time plot
trace(xmb.cc_mt_2)

% compute FFT
set(0,'DefaultFigureVisible','off');
XMB.cc_mt_2 = spec(xmb.cc_mt_2)
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

