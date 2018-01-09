
% figure 1a
% Perform SVD decomposition, and return n mode analysis

% MJH 20/06/07
% Copy chirp_9429c4.m and set for remote operation

clear all

load 9429_xmd.mat
% shot= 9429
% xmd = getXMD(shot)

% select time chunk 

tmin = 0.240
tmax = 0.241
% tmin = 0.250
% tmax = 0.270

clear ymd

Ncoils = size(xmd.omt,2)

for i=1:Ncoils
  if xmd.omt(i).data
     imin = min(find(xmd.omt(i).signal(:,1)>=tmin));
     imax = min(find(xmd.omt(i).signal(:,1)>=tmax));
     ymd.omt(i).data = 1;
     ymd.omt(i).phi  = xmd.omt(i).phi;
     ymd.omt(i).signal(1:imax-imin+1,:) = xmd.omt(i).signal(imin:imax, :);
     ymd.omt(i).signal(1:imax-imin+1,:) = xmd.omt(i).signal(imin:imax, :);     

     % average over clock - it has a huge dither MJH 08/11/06
     dt_trace = diff(ymd.omt(i).signal(:,1));
     dt   = mean(dt_trace);     

     tmin = min(ymd.omt(i).signal(:,1));
     tmax = max(ymd.omt(i).signal(:,1));     
  end;
  
  if xmd.omr(i).data
     imin = min(find(xmd.omr(i).signal(:,1)>=tmin));
     imax = min(find(xmd.omr(i).signal(:,1)>=tmax));
     ymd.omr(i).data = 1;
     ymd.omr(i).phi  = xmd.omr(i).phi;
     ymd.omr(i).signal(1:imax-imin+1,:) = xmd.omr(i).signal(imin:imax, :);
     ymd.omr(i).signal(1:imax-imin+1,:) = xmd.omr(i).signal(imin:imax, :);     
  end;

  if xmd.omv(i).data
     imin = min(find(xmd.omv(i).signal(:,1)>=tmin));
     imax = min(find(xmd.omv(i).signal(:,1)>=tmax));
     ymd.omv(i).data = 1;
     ymd.omv(i).phi  = xmd.omv(i).phi;
     ymd.omv(i).signal(1:imax-imin+1,:) = xmd.omv(i).signal(imin:imax, :);
     ymd.omv(i).signal(1:imax-imin+1,:) = xmd.omv(i).signal(imin:imax, :);     
  end;
end;

disp(['Spectrum ======================================']);
clear global deltaf
global deltaf

deltaf  = (291.0e+3-279.3e+3)/(221.5e-3-216.1e-3);
winl    = (tmax-tmin)/dt
winl    = size(ymd.omt(1).signal,1)
flow    = 250e+3
fhigh   = 350e+3;
flow    = 375e+3
flow    = 300e+3
fhigh   = 400e+3
YMD.omt = spec(ymd.omt, winl, 1, 0, flow, fhigh);

tnorm = 1e-3
fnorm = 1e+3
render_example(YMD.omt(1),tnorm, fnorm)

% save ch_9429c4.mat YMD ymd
% save ch_9429c5.mat YMD ymd

% PLOT PHASE ==================================================
% load ch_9429c.mat YMD ymd
flow   = min(YMD.omt(1).f)
fhigh  = max(YMD.omt(1).f)
[Z]    = nmode(YMD.omt,tmin,1,flow,  fhigh)
Z.shot = 9429


% pltn_paper(Z);
% return

[h,Zwin]  = pltn_chirp(Z);

[X0] = find_mode(Zwin,[265e+3 280e+3])
[X1] = find_mode(Zwin,[270e+3 290e+3])
[X2] = find_mode(Zwin,[290e+3 305e+3])
[X3] = find_mode(Zwin,[250e+3 265e+3])
[X4] = find_mode(Zwin,[300e+3 310e+3])
[X5] = find_mode(Zwin,[310e+3 330e+3])
[h]  = pltn_add(h, X0)
[h]  = pltn_add(h, X1)
[h]  = pltn_add(h, X2)
[h]  = pltn_add(h, X3)
[h]  = pltn_add(h, X4)
[h]  = pltn_add(h, X5)


% plot polarization 
% |db.B| and |db x B| at coil 3

YMD.omr(3) = spec(ymd.omr(3), winl, 1, 0, flow, fhigh);
YMD.omv(3) = spec(ymd.omv(3), winl, 1, 0, flow, fhigh);

pol.f   = YMD.omt(3).f;
pol.dbt = YMD.omt(3).F;
pol.dbr = YMD.omr(3).F;
pol.dbv = YMD.omv(3).F;

coil.R = 1.7;
coil.Z = 0.2;
coil.phi = 357;

% get efit recosntruction =======================
% eft = getEFT(shot)
load 9429_eft.mat

[eft, coil] = Bcomp(eft, coil)

% interpolate for B at tmin
pol.BR = interp1(coil.BR(:,1), coil.BR(:,2),tmin);
pol.BZ = interp1(coil.BZ(:,1), coil.BZ(:,2),tmin);
pol.Bt = interp1(coil.Bt(:,1), coil.Bt(:,2),tmin);

NAr = 8.8e-3;
NAt = 6.5e-3;
NAv = 7.5e-3;

Nf = length(pol.f)
for i=1:Nf
    pol.dbt(i) = pol.dbt(i)/(1i*2*pi*pol.f(i)*NAt);
    pol.dbr(i) = pol.dbr(i)/(1i*2*pi*pol.f(i)*NAr);
    pol.dbv(i) = pol.dbv(i)/(1i*2*pi*pol.f(i)*NAv);

    dbvec = [pol.dbr(i) pol.dbv(i) pol.dbt(i)];
    dbmag = sqrt(abs(pol.dbr(i))^2 + abs(pol.dbt(i))^2 + abs(pol.dbv(i))^2);
    Bvec  = [pol.BR pol.BZ pol.Bt];
    Bmag  = sqrt(pol.BR^2 + pol.BZ^2 + pol.Bt^2);
    
    pol.bdotB(i)   = abs(dot(dbvec, Bvec)/(dbmag*Bmag));
    bcrossB        = cross(dbvec, Bvec)/(dbmag*Bmag);
    pol.bcrossB(i) = sqrt(abs(bcrossB(1))^2 + abs(bcrossB(2))^2 + abs(bcrossB(3))^2);
end

% MJH 09/05/2013
% save chirp_9429c5.mat

[h,Zwin]  = pltn_pol(Z, pol);
[X0] = find_mode(Zwin,[265e+3 280e+3])
[X1] = find_mode(Zwin,[270e+3 290e+3])
[X2] = find_mode(Zwin,[290e+3 305e+3])
[X3] = find_mode(Zwin,[250e+3 265e+3])
[X4] = find_mode(Zwin,[300e+3 310e+3])
[X5] = find_mode(Zwin,[310e+3 330e+3])
[h]  = pltn_add(h, X0)
[h]  = pltn_add(h, X1)
[h]  = pltn_add(h, X2)
[h]  = pltn_add(h, X3)
[h]  = pltn_add(h, X4)
[h]  = pltn_add(h, X5)


% add amplitude probability
[h, X] = pltn_polC(Z, pol)
[h]    = pltn_add(h, X0)
[h]    = pltn_add(h, X1)
[h]    = pltn_add(h, X2)
[h]    = pltn_add(h, X3)
[h]    = pltn_add(h, X4)
[h]    = pltn_add(h, X5)

% add amplitude probability
[h, X] = pltn_polC(Z, pol,1)
[h]    = pltn_add(h, X0)
[h]    = pltn_add(h, X1)
[h]    = pltn_add(h, X2)
[h]    = pltn_add(h, X3)
[h]    = pltn_add(h, X4)
[h]    = pltn_add(h, X5)

return
    
