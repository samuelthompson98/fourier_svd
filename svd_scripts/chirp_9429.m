
% figure 1a
% Perform SVD decomposition, and return n mode analysis

load 9429_xmd.mat

% select time chunk 

tmin = 0.230
tmax = 0.260

Ncoils = size(xmd.omt,2)

for i=1:Ncoils
  if xmd.omt(i).data
     imin = min(find(xmd.omt(i).signal(:,1)>=tmin));
     imax = min(find(xmd.omt(i).signal(:,1)>=tmax));
     ymd.omt(i).data = 1;
     ymd.omt(i).phi  = xmd.omt(i).phi;
     ymd.omt(i).signal(1:imax-imin+1,:) = xmd.omt(i).signal(imin:imax, :);
     ymd.omt(i).signal(1:imax-imin+1,:) = xmd.omt(i).signal(imin:imax, :);     
 end;
end;

disp(['Spectrum ======================================']);
global deltaf

deltaf  = 0.8*45e+3/9e-3;
winl    = 4096*2
YMD.omt = fspec(ymd.omt, winl);

tnorm = 1e-3
fnorm = 1e+3
render_example(YMD.omt(2),tnorm, fnorm)

save ch_9429a.mat YMD ymd

return
