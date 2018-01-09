
% figure 1a
% Perform SVD decomposition, and return n mode analysis

load 9429_xmd.mat


disp(['Normalization =================================']);
winl    = 4096
norm    = spec_norm(winl)

disp(['Spectrum ======================================']);
XMD.omt = spec(xmd.omt, winl, norm);

tnorm = 1e-3
fnorm = 1e+3
render_paper(XMD.omt(2),tnorm, fnorm)
axis([0.1/tnorm 0.35/tnorm 500/fnorm 600e+3/fnorm])