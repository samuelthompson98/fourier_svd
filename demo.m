% figure 2
% Perform SVD decomposition, and return n mode analysis

addpath svd_scripts

% last item gets popped to top of stack....

load struc_xmd.mat

% MJH processing 15/06/07: remove mean
dt   = 5.0e-7; % 0.5 mus
tmax = 0.3;

for i = 1:3
    xmd.omt(i).signal(:,1) = 0:dt:tmax;
end

%Linearly increasing frequency
A1 = 1;%5;
f1 = 15e+4;
n1 = 15;
%Constant frequency
A2 = 5;
f2 = 6e+4;
n2 = -5;
%Linearly decreasing frequency
A3 = 0;%5;
f3 = 10e+4;
n3 = 8;

for i = 1:3
    xmd.omt(i).signal(:,2) = A1 * cos(xmd.omt(i).signal(:,1) .^ 2 * 2* pi *f1 + n1 * xmd.omt(i).phi )  
    xmd.omt(i).signal(:,2) = xmd.omt(i).signal(:,2) + A2 * cos(xmd.omt(i).signal(:,1) * 2* pi *f2 + n2 * xmd.omt(i).phi );
    %xmd.omt(i).signal(:,2) = xmd.omt(i).signal(:,2) + A3 * cos(f3 * (xmd.omt(i).signal(:,1) - xmd.omt(i).signal(:,1) .^ 2) * 2* pi + n3 * xmd.omt(i).phi );
end

% add pink noise taken from
% https://ccrma.stanford.edu/~jos/sasp/Example_Synthesis_1_F_Noise.html
Nt = size(xmd.omt(1).signal,1)
Nx = Nt;  
B = [0.049922035 -0.095993537 0.050612699 -0.004408786];
A = [1.0 -2.494956002   2.017265875  -0.522189400];
disp(max(abs(roots(A))));
nT60 = round(log(1000)/(1-max(abs(roots(A))))); % T60 est.

beta = 0.0;
for i=1:3
    v = randn(1,Nx+nT60); % Gaussian white noise: N(0,1)
    x = filter(B,A,v);    % Apply 1/F roll-off to PSD
    x = x(nT60+1:end);    % Skip transient response
    xmd.omt(i).signal(:,2) = xmd.omt(i).signal(:,2) + beta * x';
end
disp(nT60);
disp(size(x));
%plot(1:1:size(x), x)

disp(['Normalization =================================']);
winl    = 2048
norm    = spec_norm(winl)

disp(['Spectrum ======================================']);
XMD.omt = spec(xmd.omt, winl, norm);

tnorm = 1e-3
fnorm = 1e+3
%This function gives an error - had to change some content
render_example(XMD.omt(1), tnorm, fnorm) %Figure 1

it = min(find(XMD.omt(1).t >= 0.25)) %0.165
figure
size(XMD.omt(1).f)
size(abs(XMD.omt(1).F(:,it)))
semilogy(XMD.omt(1).f, abs(XMD.omt(1).F(:,it))) %Figure 2

toff   = min(xmd.omt(1).signal(:,1));

get_frequency1 = @(t) 2 * f1 * t;
get_frequency2 = @(t) f2 * ones(size(t))
get_frequency3 = @(t) f3 * (1 - 2 * t)
times = 0.0:0.05:0.29
plot_amplitude_and_mode_number_relative_differences(times', XMD.omt, get_frequency1, A1, n1);
plot_amplitude_and_mode_number_relative_differences(times', XMD.omt, get_frequency2, A2, n2);
%plot_amplitude_and_mode_number_relative_differences(times', XMD.omt, get_frequency3, A3, n3);

%{
% M=1 mode
[Z1]    = nmode(XMD.omt,0.2,1,500,100e+3) %0.165
Z1.shot = 9429
[ Z1_noise ]  = fit_mag_power3( Z1) %Figure 3
pltn_M1data(Z1, Z1_noise); %Figure 4

% M=2 mode
[Z2]    = nmode(XMD.omt,0.15,2,500,100e+3)
Z2      = nmode_filter(Z2);

Z2.shot = 9429
[ Z2_noise ]  = fit_mag_power3( Z2) %Figure 5

pltn_M2data(Z2, Z2_noise); %Figure 6

[Z21]    = nmode(XMD.omt,0.25,2,500,100e+3)
Z21      = nmode_filter(Z21);
Z21.shot = 9429
[ Z21_noise ]  = fit_mag_power3( Z21) %Figure 7

pltn_M2data(Z21, Z21_noise); %Figure 8

ts = [0.11; 0.15; 0.18; 0.2; 0.22; 0.25; 0.29]
%}

%{
for i = 1:1%size(times')
    [Z2]    = nmode(XMD.omt,times(i),2,500,100e+3)
    1e5 * max(abs(Z2.a(:, 1)))
    Z2      = nmode_filter(Z2);
    Z2.shot = 9429
    [ Z2_noise ]  = fit_mag_power3( Z2)
    pltn_M2data(Z2, Z2_noise);
end
%}

save struc_XMD.mat XMD

return