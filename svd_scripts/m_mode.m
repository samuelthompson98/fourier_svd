
% get data
xmb=getXMB(4505);
xmb=getXMB(6326);

% compute FFT
set(0,'DefaultFigureVisible','off');
XMB.cc_mv_2=spec(xmb.cc_mv_2)
set(0,'DefaultFigureVisible','on');

% render centre column midplane
render(XMB.cc_mv_2(20));

% plot real part of signal at a particular time slice and frequency
pol_phase(XMB.cc_mv_2,0.28,4500)
pol_phase_1(XMB.cc_mv_2,0.28,4500)
pol_phase_2(XMB.cc_mv_2,0.28)

pol_phase(XMB.cc_mv_2,0.2,8000)
pol_phase_1(XMB.cc_mv_2,0.2,8000)
pol_phase_2(XMB.cc_mv_2,0.2)

% =====================================================
% get data
xmc=getXMC(4669);

% compute FFT
set(0,'DefaultFigureVisible','off');
XMC.cc_mv_2=spec(xmc.cc_mv_2)
set(0,'DefaultFigureVisible','on');

% render centre column midplane
render(XMC.cc_mv_2(20));

% compute FFT
set(0,'DefaultFigureVisible','off');
XMC.ob_mv_2=spec(xmc.ob_mv_2)
set(0,'DefaultFigureVisible','on');

% render centre column midplane
render(XMC.ob_mv_2(10));

% plot real part of signal at a particular time slice
pol_phase_2(XMC.cc_mv_2,0.12)

% =====================================================
% get data
xmc=getXMC(6894);
xmb=getXMB(6894);

% compute FFT
set(0,'DefaultFigureVisible','off');
XMB.cc_mv_2=spec(xmb.cc_mv_2)
set(0,'DefaultFigureVisible','on');

% render centre column midplane
render(XMB.cc_mv_2(20));

pol_phase_2(XMB.cc_mv_2,0.2)

% compute FFT
set(0,'DefaultFigureVisible','off');
XMC.ob_mv_2=spec(xmc.cc_mv_2)
set(0,'DefaultFigureVisible','on');



xmb=getXMB(6894);
xmb.cc_mt_2(1).data=0;
xmb.cc_mt_2(2).data=0;
% compute FFT
set(0,'DefaultFigureVisible','off');
XMB.cc_mt_2=spec(xmb.cc_mt_2)
set(0,'DefaultFigureVisible','on');

% render centre column midplane
render(XMB.cc_mt_2(10));

% plot real part of signal at a particular time slice
pol_phase_2(XMC.cc_mv_2,0.12)

