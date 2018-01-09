
% figure 2
% Perform SVD decomposition, and return n mode analysis
diary('fig_alpha_noise_diary.txt');

load 9425_xmd.mat

disp(['Fix Polarity =================================']);
pol_fix = 0;
if pol_fix
  xmd.omt(1).signal(:,2)  = - xmd.omt(1).signal(:,2);
  xmd.omt(2).signal(:,2)  = + xmd.omt(2).signal(:,2);
  xmd.omt(3).signal(:,2)  = - xmd.omt(3).signal(:,2);
end;

tmin       = 0.239;
tmax       = 0.35;
imin       = min(find(xmd.omt(1).signal(:,1)>tmin))
imax       = max(find(xmd.omt(1).signal(:,1)<tmax))

ymd.shot  = xmd.shot;
for i=1:3
	ymd.omt(i).data  = xmd.omt(i).data
	ymd.omt(i).phi   = xmd.omt(i).phi
	ymd.omt(i).signal(:,1) = xmd.omt(i).signal(imin:imax,1); 
	ymd.omt(i).signal(:,2) = xmd.omt(i).signal(imin:imax,2); 
end


disp(['Normalization =================================']);
winl    = 4096
norm    = spec_norm(winl)

disp(['Spectrum ======================================']);
YMD.omt = spec(ymd.omt, winl, norm);

save 9425_YMD.mat YMD

return

Nwin = length(XMD.omt(1).t)
for i=1:Nwin
    try 
    	Z(i)    = nmode(XMD.omt,XMD.omt(1).t(i),1,500,1e+6);
	    save 9425_Z.mat Z XMD
    catch 
        return;
    end;
end;

return
