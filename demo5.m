addpath svd_scripts
load struc_xmd.mat

dt   = 5.0e-7; % 0.5 mus
tmax = 0.3;
num_coils = 3;

for i = 1:num_coils
    xmd.omt(i).signal(:,1) = 0:dt:tmax;
end

A1 = 1;
f1 = 50e+3;
n1 = 10;
A2 = 1;
f2 = 100e+3;
n2 = -10;

for i = 1:num_coils
    xmd.omt(i).signal(:,2) = A1 * cos(xmd.omt(i).signal(:,1) ...
        * 2 * pi * f1 + n1 * xmd.omt(i).phi );%  + A2 * cos(xmd.omt(1).signal(:,1).^2 * 2* pi *f2 + n2 * xmd.omt(1).phi ); 
end

Nx = size(xmd.omt(1).signal,1);  
B = [0.049922035 -0.095993537 0.050612699 -0.004408786];
A = [1 -2.494956002   2.017265875  -0.522189400];
nT60 = round(log(1000)/(1-max(abs(roots(A))))); % T60 est.

beta = 0.0;%0.1;
for i=1:3
    v = randn(1,Nx+nT60); % Gaussian white noise: N(0,1)
    x = filter(B,A,v);    % Apply 1/F roll-off to PSD
    x = x(nT60+1:end);    % Skip transient response
    xmd.omt(i).signal(:,2) = xmd.omt(i).signal(:,2) + beta * x';
end

winl    = 2048
norm    = spec_norm(winl)
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

% M=2 mode
[Z2]    = nmode(XMD.omt,0.165,2,500,100e+3)
Z2      = nmode_filter(Z2);
figure;
plot(Z2.f, abs(Z2.a(:, 1)));

Z2.shot = 9429
[ Z2_noise ]  = fit_mag_power3( Z2)

pltn_M2data(Z2, Z2_noise);

amplitude = max(abs(Z2.a(:, 1)))
frequency = Z2.f(find(abs(Z2.a(:,1)) == amplitude))
real_amplitude = get_real_amplitude(amplitude, frequency)

save struc_XMD.mat XMD

return