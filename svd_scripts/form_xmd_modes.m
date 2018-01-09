
function [Z,XMD]= form_xmd_modes(xmd, timeslice, nsimul, Nt)
% MJH: October 5, 2005
% modified from jessica/example_test1.m
% Compute spectrogram at different time intervals
% dt = time increment length in spec = winl/fs
% spectra computed with overlap of 
trace(xmd.omt)
%compute FFT
set(0,'DefaultFigureVisible','off');
XMB.omt = spec(xmd.omt)
set(0,'DefaultFigureVisible','on');

XMB.shot     = xmd.shot;
ncoil_sample = 3;
render(XMB.omt(ncoil_sample));

% SVD in n at t=timeslice
disp(['Number of simultaneously modes to fit are ',num2str(nsimul)]);

i_timeslice = min(find(XMB.omt(ncoil_sample).t >= timeslice));
timeslice0  = timeslice;
timeslice1  = XMB.omt(ncoil_sample).t(i_timeslice);
dt          = XMB.omt(ncoil_sample).t(i_timeslice+1)-XMB.omt(ncoil_sample).t(i_timeslice);
disp(['timeslice = ',num2str(timeslice0),' => ', num2str(timeslice1)]);

% # timeslices for last graph

for k=1:Nt
  temp = nmode(XMB.omt,timeslice,nsimul)
  Z(k).f = temp.f;
  Z(k).n = temp.n;
  Z(k).a = temp.a;
  Z(k).dF = temp.dF;
  Z(k).t = temp.t;
  Z(k).dt = dt;
  Z(k).Nc = temp.Nc;
  Z(k).shot = xmd.shot;
  save Zout.mat Z;
  timeslice = timeslice + dt;
end;

pause(0.1);
pltn(Z(1))
pause(0.1);

return;
