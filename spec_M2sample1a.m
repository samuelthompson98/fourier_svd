
% figure 2
% Perform SVD decomposition, and return n mode analysis

% load 9429_xmd.mat
% load 9429_xmd_17_06_07.mat
% addpath 'c:\Documents and Settings\vanessa\desktop\SVD\SVD5'
% addpath /home/hol105/MHD_codes/matlab/svd_scripts
% addpath /data/Laptop_2009_Windows/SVD/SVD5
addpath svd_scripts

% last item gets popped to top of stack....
% addpath /home/hol105/MHD_codes/matlab/svd_scripts


load struc_xmd.mat

% MJH processing 15/06/07: remove mean

dt   = 5.0e-7; % 0.5 mus
tmax = 0.3;

xmd.omt(1).signal(:,1) = 0:dt:tmax;
xmd.omt(2).signal(:,1) = 0:dt:tmax;
xmd.omt(3).signal(:,1) = 0:dt:tmax;


A1 = 5;
f1 = 50e+3;
n1 = 10;
A2 = 1;
f2 = 100e+3;
n2 = -10;

xmd.omt(1).signal(:,2) = 0;%A1 * cos(xmd.omt(1).signal(:,1) * 2* pi *f1 + n1 * xmd.omt(1).phi )  + A2 * cos(xmd.omt(1).signal(:,1).^2 * 2* pi *f2 + n2 * xmd.omt(1).phi ); 
xmd.omt(2).signal(:,2) = 0;%A1 * cos(xmd.omt(2).signal(:,1) * 2* pi *f1 + n1 * xmd.omt(2).phi )  + A2 * cos(xmd.omt(2).signal(:,1).^2 * 2* pi *f2 + n2 * xmd.omt(2).phi ); 
xmd.omt(3).signal(:,2) = 0;%A1 * cos(xmd.omt(3).signal(:,1) * 2* pi *f1 + n1 * xmd.omt(3).phi )  + A2 * cos(xmd.omt(3).signal(:,1).^2 * 2* pi *f2 + n2 * xmd.omt(3).phi ); 

% add noise to signal components
Nt   = size(xmd.omt(1).signal,1)
beta = 0.0;
for i=1:3
    xmd.omt(i).signal(:,2) = xmd.omt(i).signal(:,2) + beta * randn(Nt,1)
end

% add pink noise taken from
% https://ccrma.stanford.edu/~jos/sasp/Example_Synthesis_1_F_Noise.html


Nx = 2^16;  % number of samples to synthesize
Nx = Nt;  
B = [0.049922035 -0.095993537 0.050612699 -0.004408786];
A = [1 -2.494956002   2.017265875  -0.522189400];
nT60 = 0;%round(log(1000)/(1-max(abs(roots(A))))) % T60 est.

beta = 0.1;
for i=1:3
    v = randn(1,Nx+nT60); % Gaussian white noise: N(0,1)
    x = filter(B,A,v);    % Apply 1/F roll-off to PSD
    x = x(nT60+1:end);    % Skip transient response
    xmd.omt(i).signal(:,2) = xmd.omt(i).signal(:,2) + beta * x';
end

disp(['Normalization =================================']);
winl    = 4096
winl    = 2048
norm    = spec_norm(winl)


disp(['Spectrum ======================================']);
XMD.omt = spec(xmd.omt, winl, norm);

tnorm = 1e-3
fnorm = 1e+3
render_example(XMD.omt(1),tnorm, fnorm)

it = min(find(XMD.omt(1).t >= 0.165))
figure
semilogy(XMD.omt(1).f, abs(XMD.omt(1).F(:,it)))

toff   = min(xmd.omt(1).signal(:,1));
% disp(['computation time = ', num2str(0.069+toff)]);
% [Z]    = nmode(XMD.omt,0.069+toff,1,500,100e+3)

% M=1 mode
[Z1]    = nmode(XMD.omt,0.165,1,500,100e+3)
Z1.shot = 9429
[ Z1_noise ]  = fit_mag_power3( Z1)

pltn_M1data(Z1, Z1_noise);

% pltn_chirp(Z1);

% M=2 mode
[Z2]    = nmode(XMD.omt,0.165,2,500,100e+3)
Z2      = nmode_filter(Z2);

Z2.shot = 9429
[ Z2_noise ]  = fit_mag_power3( Z2)

pltn_M2data(Z2, Z2_noise);

[Z21]    = nmode(XMD.omt,0.25,2,500,100e+3)
Z21      = nmode_filter(Z21);
Z21.shot = 9429
[ Z21_noise ]  = fit_mag_power3( Z21)

pltn_M2data(Z21, Z21_noise);

save struc_XMD.mat XMD

return





