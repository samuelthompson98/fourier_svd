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
    xmd.omt(i).signal(:,2) = A1 * cos(xmd.omt(i).signal(:,1) .^ 2 * 2 * ...
        pi *f1 + n1 * xmd.omt(i).phi )  
    xmd.omt(i).signal(:,2) = xmd.omt(i).signal(:,2) + A2 * ...
        cos(xmd.omt(i).signal(:,1) * 2* pi *f2 + n2 * xmd.omt(i).phi );
    %xmd.omt(i).signal(:,2) = xmd.omt(i).signal(:,2) + A3 * cos(f3 * (xmd.omt(i).signal(:,1) - xmd.omt(i).signal(:,1) .^ 2) * 2* pi + n3 * xmd.omt(i).phi );
end

disp("noise")
noise = 10 .^ (-2:1:0)';
get_frequency = {@(t) f2 * ones(size(t)); @(t) 2 * f1 * t};
amplitude = [A2; A1];
n = [n2; n1];
mode_crossing_time = 0.2;
num_modes = 2;

FdF = zeros(size(noise, 1), size(n, 1));
Fda = zeros(size(noise, 1), size(n, 1));
a = zeros(size(noise, 1), size(n, 1));
rmsd_amplitude = zeros(size(noise, 1), size(n, 1));
rmsd_n = zeros(size(noise, 1), size(n, 1));

for i = 1:size(noise)
    [confidence_object] = plot_relative_error_with_noise_amplitude(...
        xmd.omt, noise(i), get_frequency, amplitude, n, num_modes, ...
        mode_crossing_time);
    FdF(i, :) = confidence_object.FdF;
    Fda(i, :) = confidence_object.Fda;
    a(i, :) = confidence_object.a;
    confidence_object.rmsd_amplitude
    rmsd_amplitude(i, :) = confidence_object.rmsd_amplitude;
    rmsd_n(i, :) = confidence_object.rmsd_n;
end

for i = 1:size(n)
    title2a = ' for mode number ';
    title2b = int2str(i);
    title2 = strcat({title2a}, {title2b});
    C_r_title = strcat("$$C_r$$", title2);
    C_beta_title = strcat("$$C_{\beta}$$", title2);
    alpha_title = strcat("$$\alpha_{fitted}$$", title2);
    rmsd_a_title = strcat("RMSD $$\frac{\Delta \alpha}{\alpha}$$", title2);
    rmsd_n_title = strcat("RMSD $$\frac{\Delta n}{n}$$", title2);
    plot_value(noise, FdF(:, i), "$$\beta$$", "$$C_r$$", C_r_title, ...
        @loglog, 'latex');
    plot_value(noise, Fda(:, i), "$$\beta$$", "$$C_{\beta}$$", ...
        C_beta_title, @loglog, 'latex');
    plot_value(noise, a(:, i), "$$\beta$$", "$$\alpha_{fitted}$$", ...
        alpha_title, @semilogx, 'latex');
    plot_value(noise, rmsd_amplitude(:, i), "$$\beta$$", ...
        "RMSD $$\frac{\Delta \alpha}{\alpha}$$", rmsd_a_title, ...
        @semilogx, 'latex');
    plot_value(noise, rmsd_n(:, i), "$$\beta$$", ...
        "RMSD $$\frac{\Delta n}{n}$$", rmsd_n_title, @semilogx, 'latex');
end

return