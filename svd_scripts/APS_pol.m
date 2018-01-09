clear all;


% XMB 6590 =======================================================

xmb_590=getXMB(6590);

% remove bad data
xmb_590.cc_mv_2(27).data   =0;
xmb_590.cc_mv_2(26).data   =0;
xmb_590.cc_mv_2(14).data  =0;
xmb_590.cc_mv_2(21).data  =0;
XMB_590.cc_mv_2(27).data   =0;
XMB_590.cc_mv_2(26).data   =0;
XMB_590.cc_mv_2(14).data  =0;
XMB_590.cc_mv_2(21).data  =0;

% fix polarity
for i=21:40
  xmb_590.cc_mv_2(i).signal(:,2)  = - xmb_590.cc_mv_2(i).signal(:,2);
end;

disp(['Input data ================================ ']);
Nt=1e+6;
for i=1:40
  disp(['Nt = ', num2str(size(xmb_590.cc_mv_2(i).signal,1))]);
  Nt = min([Nt size(xmb_590.cc_mv_2(i).signal,1)]);
end;
temp            = xmb_590.cc_mv_2;
xmb_590.cc_mv_2 = rmfield(xmb_590.cc_mv_2,'signal');
for i=1:40 
  xmb_590.cc_mv_2(i).signal(1:Nt,:) = temp(i).signal(1:Nt,:);
end;
disp(['Fixed data ================================ ']);
for i=1:40
  disp(['Nt = ', num2str(size(xmb_590.cc_mv_2(i).signal,1))]);
  Nt = min([Nt size(xmb_590.cc_mv_2(i).signal,1)]);
end;

trace(xmb_590.cc_mv_2)

% compute FFT
set(0,'DefaultFigureVisible','off');
XMB_590.cc_mv_2=spec(xmb_590.cc_mv_2)
set(0,'DefaultFigureVisible','on');

% render centre column midplane
render(XMB_590.cc_mv_2(20));

pol_phase(XMB_590.cc_mv_2,0.1994,17500)

return;

% XMC 6894 =======================================================

xmc_894=getXMC(6894);

% remove bad data
xmc_894.cc_mt_2(1).data   =0;
xmc_894.cc_mt_2(2).data   =0;
xmc_894.cc_mt_2(3).data   =0;
xmc_894.cc_mt_2(4).data   =0;
xmc_894.cc_mt_2(5).data   =1;
xmc_894.cc_mt_2(6).data   =0;
xmc_894.cc_mt_2(7).data   =1;
xmc_894.cc_mt_2(8).data   =0;
xmc_894.cc_mt_2(9).data   =1;
xmc_894.cc_mt_2(10).data  =1;
xmc_894.cc_mt_2(11).data  =0;
xmc_894.cc_mt_2(12).data  =0;

% fix polarity
xmc_894.cc_mt_2(3).signal(:,2)  = - xmc_894.cc_mt_2(3).signal(:,2);
xmc_894.cc_mt_2(5).signal(:,2)  = + xmc_894.cc_mt_2(5).signal(:,2);
xmc_894.cc_mt_2(6).signal(:,2)  = - xmc_894.cc_mt_2(6).signal(:,2);
xmc_894.cc_mt_2(7).signal(:,2)  = - xmc_894.cc_mt_2(7).signal(:,2);
xmc_894.cc_mt_2(8).signal(:,2)  = - xmc_894.cc_mt_2(8).signal(:,2);
xmc_894.cc_mt_2(9).signal(:,2)  = - xmc_894.cc_mt_2(9).signal(:,2);
xmc_894.cc_mt_2(10).signal(:,2) = - xmc_894.cc_mt_2(10).signal(:,2);
xmc_894.cc_mt_2(11).signal(:,2) = - xmc_894.cc_mt_2(11).signal(:,2);

% define toroidal postion
dphi = 2*pi/12;
for i=1:12
  xmc_894.cc_mt_2(i).phi= dphi*i;
end;

trace(xmc_894.cc_mt_2)

% compute FFT
set(0,'DefaultFigureVisible','off');
XMC_894.cc_mt_2=spec(xmc_894.cc_mt_2)
set(0,'DefaultFigureVisible','on');

% render centre column midplane
render(XMC_894.cc_mt_2(5));

return;

% XMB 6894 =======================================================
% get data
xmb_894=getXMB(6894);
% xmb_894=getXMB(6894);

% fix 6894 =======================================
% remove bad data
xmb_894.cc_mt_2(1).data   =0;
xmb_894.cc_mt_2(4).data   =0;
xmb_894.cc_mt_2(12).data  =0;

% fix polarity
xmb_894.cc_mt_2(1).signal(:,2)  = - xmb_894.cc_mt_2(1).signal(:,2);
xmb_894.cc_mt_2(2).signal(:,2)  = + xmb_894.cc_mt_2(2).signal(:,2);
xmb_894.cc_mt_2(3).signal(:,2)  = - xmb_894.cc_mt_2(3).signal(:,2);
xmb_894.cc_mt_2(4).signal(:,2)  = - xmb_894.cc_mt_2(4).signal(:,2);
xmb_894.cc_mt_2(5).signal(:,2)  = + xmb_894.cc_mt_2(5).signal(:,2);
xmb_894.cc_mt_2(6).signal(:,2)  = - xmb_894.cc_mt_2(6).signal(:,2);
xmb_894.cc_mt_2(7).signal(:,2)  = - xmb_894.cc_mt_2(7).signal(:,2);
xmb_894.cc_mt_2(8).signal(:,2)  = - xmb_894.cc_mt_2(8).signal(:,2);
xmb_894.cc_mt_2(9).signal(:,2)  = - xmb_894.cc_mt_2(9).signal(:,2);
xmb_894.cc_mt_2(10).signal(:,2) = - xmb_894.cc_mt_2(10).signal(:,2);
xmb_894.cc_mt_2(11).signal(:,2) = - xmb_894.cc_mt_2(11).signal(:,2);
xmb_894.cc_mt_2(12).signal(:,2) = - xmb_894.cc_mt_2(12).signal(:,2);

% define toroidal postion
dphi = 2*pi/12;
for i=1:12
  xmb_894.cc_mt_2(i).phi= dphi*i;
end;

Nt = 1e+6;

disp(['Input data ================================ ']);
for i=1:12
  disp(['Nt = ', num2str(size(xmb_894.cc_mt_2(i).signal,1))]);
  Nt = min([Nt size(xmb_894.cc_mt_2(i).signal,1)]);
end;
temp            = xmb_894.cc_mt_2;
xmb_894.cc_mt_2 = rmfield(xmb_894.cc_mt_2,'signal');
for i=1:12 
  xmb_894.cc_mt_2(i).signal(1:Nt,:) = temp(i).signal(1:Nt,:);
end;
disp(['Fixed data ================================ ']);
for i=1:12
  disp(['Nt = ', num2str(size(xmb_894.cc_mt_2(i).signal,1))]);
  Nt = min([Nt size(xmb_894.cc_mt_2(i).signal,1)]);
end;
trace(xmb_894.cc_mt_2)

% compute FFT
set(0,'DefaultFigureVisible','off');
XMB_894.cc_mt_2=spec(xmb_894.cc_mt_2)
set(0,'DefaultFigureVisible','on');

% render centre column midplane
render(XMB_894.cc_mt_2(3));
