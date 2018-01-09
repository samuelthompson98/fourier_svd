
% fit_noise.m

load 9425_xmd.mat

tend = 0.245;
i_tstart = min(find(xmd.omt(1).signal(:,1) > tend));
i_tstop  = length(xmd.omt(1).signal(:,1) );

noise.std = std(xmd.omt(1).signal(i_tstart:i_tstop,2))