
% figure 1a
% Perform SVD decomposition, and return n mode analysis

load 9429_xmd.mat

% select time chunk 

tmin = 0.240
tmax = 0.250

Ncoils = size(xmd.omt,2)

for i=1:Ncoils
  if xmd.omt(i).data
     imin = min(find(xmd.omt(i).signal(:,1)>=tmin));
     imax = min(find(xmd.omt(i).signal(:,1)>=tmax));
     ymd.omt(i).data = 1;
     ymd.omt(i).phi  = xmd.omt(i).phi;
     ymd.omt(i).signal(1:imax-imin+1,:) = xmd.omt(i).signal(imin:imax, :);
     ymd.omt(i).signal(1:imax-imin+1,:) = xmd.omt(i).signal(imin:imax, :);     
     dt = ymd.omt(i).signal(2,1) - ymd.omt(i).signal(1,1);
 end;
end;

disp(['Spectrum ======================================']);
clear global deltaf
global deltaf

deltaf  = 45e+3/9e-3;
winl    = (tmax-tmin)/dt
winl    = size(ymd.omt(1).signal,1)
flow    = 300e+3
fhigh   = 400e+3
YMD.omt(1) = fspec(ymd.omt(1), winl, 1, 0, flow, fhigh);
% YMD.omt(1) = spec(ymd.omt(1), winl, 1, 0, flow, fhigh);

tnorm = 1e-3
fnorm = 1e+3
render_example(YMD.omt(1),tnorm, fnorm)

% save ch_9429a.mat -v6 YMD ymd

return

% PLOT PHASE ==================================================
[Z]    = nmode(YMD.omt,0.239,2,200e+3,400e+3)
[Z]    = nmode(YMD.omt,0.2435,2,200e+3,400e+3)
Z.shot = 9429

pltn_paper(Z);


return
