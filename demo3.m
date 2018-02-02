addpath svd_scripts
load struc_xmd.mat

dt   = 5.0e-7; % 0.5 mus
tmax = 5.0e-3;
for i = 1:3
    xmd.omt(i).signal(:,1) = 0:dt:tmax;
end

for i = 1:3
    xmd.omt(i).signal(:,2) = A(1) * ...
        cos(xmd.omt(i).signal(:,1) * 2 * pi * f2 + n(1) * xmd.omt(i).phi );
    xmd.omt(i).signal(:,2) = xmd.omt(i).signal(:,2) + A(2) * ...
        cos(xmd.omt(i).signal(:,1) * 2 * pi * f2 + n(2) * xmd.omt(i).phi );
end

noise_amplitude = 10 .^ (-1:0.2:2)';
get_frequency = @(t) f2;
mode_crossing_time = tmax / 2;
n = [15; -5];
amplitude_ratios = 10 .^ (0:0.2:2)';
cutoff_amplitude = zeros(size(amplitude_ratios, 1), size(n, 1));

for i = 1:size(amplitude_ratios)
    cutoff_amplitude(i, :) = get_cutoff_noise_amplitude(xmd.omt, ...
        noise_amplitude, amplitude_ratios(i), mode_crossing_time, n);
end

for i = 1:size(n)
    title1 = "$$\beta_{cutoff}$$ vs. $$\frac{A_1}{A_2}$$ for mode number ";
    title2 = int2str(i);
    graph_title = strcat(title1, title2);
    plot_value(amplitude_ratios, cutoff_amplitude(:, i), ...
        "$$\frac{A_1}{A_2}$$", "$$\beta_{cutoff}$$", ...
        graph_title, @semilogx, 'latex');
end

return