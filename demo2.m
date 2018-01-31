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

disp("noise")
noise = 10 .^ (-3:4:1)';
get_frequency = {@(t) 2 * f1 * t; @(t) f2 * ones(size(t))};
amplitude = [A1; A2];
n = [n1; n2];
mode_crossing_time = 0.2;
num_modes = 2;

FdF = zeros(size(noise, 1), size(n, 1));
Fda = zeros(size(noise, 1), size(n, 1));
a = zeros(size(noise, 1), size(n, 1));
rmsd_amplitude = zeros(size(noise, 1), size(n, 1), num_modes);
rmsd_n = zeros(size(noise, 1), size(n, 1), num_modes);

for i = 1:size(noise)
    [confidence_object] = plot_relative_error_with_noise_amplitude(xmd.omt, noise(i), get_frequency, amplitude, n, num_modes, mode_crossing_time);
    FdF(i, :) = confidence_object.FdF;
    Fda(i, :) = 1 - confidence_object.Fda;
    a(i, :) = confidence_object.a;
    rmsd_amplitude(i, :, :) = confidence_object.rmsd_amplitude;
    confidence_object.rmsd_n
    rmsd_n(i, :, :) = confidence_object.rmsd_n;
end

disp('noise')
noise
disp('FdF')
FdF
disp('Fda')
Fda
disp('a')
a

for i = 1:2
    figure;
    loglog(noise, FdF(:, i));
    xlabel("Noise amplitude", 'FontSize', 24);
    ylabel("$$C_r$$", 'Interpreter', 'none', 'FontSize', 24);
    figure;
    loglog(noise, Fda(:, i));
    xlabel("Noise amplitude", 'FontSize', 24);
    ylabel("$$1 - C_{\beta}$$", 'Interpreter', 'latex', 'FontSize', 24);
    figure;
    plot(noise, a(:, i));
    xlabel("Noise amplitude", 'FontSize', 24);
    ylabel("$$\alpha$$", 'Interpreter', 'latex', 'FontSize', 24);
end

return