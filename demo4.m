addpath svd_scripts
load struc_xmd.mat

dt   = 5.0e-7; % 0.5 mus
tmax = 5.0e-3;
for i = 1:3
    xmd.omt(i).signal(:,1) = 0:dt:tmax;
end

noise_amplitude = 30:30:120;
get_frequency = @(t) f2;
mode_crossing_time = tmax / 2;
nvals = (-20:10:20)';
num_modes = 2
amplitude_ratios = 10 .^ (0:0.5:2)';
cutoff_amplitude = zeros(size(nvals, 1), size(nvals, 1), ...
    size(amplitude_ratios, 1), num_modes);
num_trials = 3;
amplitude_tolerance = 0.1;

for i = 1:size(nvals)
    for j = 1:size(nvals)
        n = [nvals(i); nvals(j)];
        for k = 1:size(amplitude_ratios)
            for m = 1:num_trials
                this_cutoff_amplitude = (get_cutoff_noise_amplitude(...
                    xmd.omt, noise_amplitude, amplitude_ratios(k), ...
                    mode_crossing_time, n));
                for l = 1:size(this_cutoff_amplitude)
                    cutoff_amplitude(j, k, i, l) = ...
                        cutoff_amplitude(j, k, i, l) + ...
                        this_cutoff_amplitude(l);
                end
            end
        end
    end
end
cutoff_amplitude = cutoff_amplitude / 3;

for i = 1:size(nvals)
    for j = 1:num_modes
        title1 = ...
            "$$\beta_{cutoff}$$ vs. $$\frac{A_1}{A_2}$$ and $$n_2$$ for $$n_1 =$$";
        title2 = int2str(nval(i));
        title3 = " and mode number ";
        title4 = int2str(j);
        graph_title = strcat(title1, title2, title3, title4);
        figure;
        surf(nvals, amplitude_ratios, cutoff_amplitude(:, :, i, j));
        set(gca, 'YScale', 'log');
        title(graph_title, 'Interpreter', 'Latex');
        xlabel("$$n_2$$", 'Interpreter', 'Latex');
        ylabel("$$\frac{A_2}{A_1}$$", 'Interpreter', 'Latex');
        zlabel("$$\beta_{cutoff}$$", 'Interpreter', 'Latex');
        drawnow
    end
end

return