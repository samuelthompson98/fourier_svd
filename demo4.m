addpath svd_scripts
load struc_xmd.mat

dt   = 5.0e-7; % 0.5 mus
tmax = 5.0e-3;
for i = 1:3
    xmd.omt(i).signal(:,1) = 0:dt:tmax;
end

noise_amplitude = 2:0.2:3;
get_frequency = @(t) f2;
mode_crossing_time = tmax / 2;
nvals = (-20:20:20)';
num_modes = 2;
amplitude_ratios = 10 .^ (0:1:2)';
n_cutoff_amplitude = zeros(size(nvals, 1), size(nvals, 1), ...
    size(amplitude_ratios, 1), num_modes);
A_cutoff_amplitude = zeros(size(nvals, 1), size(nvals, 1), ...
    size(amplitude_ratios, 1), num_modes);
num_trials = 3;
correct_trials_expected = num_trials - 1;
amplitude_tolerance = 0.1;

for i = 1:size(nvals)
    for j = 1:size(nvals)
        n = [nvals(i); nvals(j)];
        for k = 1:size(amplitude_ratios)
            for m = 1:num_trials
                [this_n_cutoff_amplitude, this_A_cutoff_amplitude] = ...
                    get_cutoff_noise_amplitude(...
                    xmd.omt, noise_amplitude, amplitude_ratios(k), ...
                    mode_crossing_time, n, amplitude_tolerance);
                for l = 1:size(this_n_cutoff_amplitude)
                    n_cutoff_amplitude(j, k, i, l) = ...
                        n_cutoff_amplitude(j, k, i, l) + ...
                        this_n_cutoff_amplitude(l);
                    A_cutoff_amplitude(j, k, i, l) = ...
                        n_cutoff_amplitude(j, k, i, l) + ...
                        this_A_cutoff_amplitude(l);
                end
            end
        end
    end
end

n_cutoff_amplitude = n_cutoff_amplitude / num_trials;
A_cutoff_amplitude = A_cutoff_amplitude / num_trials;

for i = 1:size(nvals)
    for j = 1:num_modes
        title1 = "$$\beta_{A";
        title2 = "$$\beta_{n";
        title3 = ...
            ", cutoff}$$ vs. $$\frac{A_1}{A_2}$$ and $$n_2$$ for $$n_1 =$$";
        title4 = int2str(nvals(i));
        title5 = " and mode number ";
        title6 = int2str(j);
        title_a = strcat(title1, title3, title4, title5, title6);
        title_b = strcat(title2, title3, title4, title5, title6);
        figure;
        surf(nvals, amplitude_ratios, n_cutoff_amplitude(:, :, i, j));
        set(gca, 'YScale', 'log');
        title(title_a, 'Interpreter', 'Latex');
        xlabel("$$n_2$$", 'Interpreter', 'Latex');
        ylabel("$$\frac{A_2}{A_1}$$", 'Interpreter', 'Latex');
        zlabel("$$\beta_{n, cutoff}$$", 'Interpreter', 'Latex');
        figure;
        surf(nvals, amplitude_ratios, A_cutoff_amplitude(:, :, i, j));
        set(gca, 'YScale', 'log');
        title(title_b, 'Interpreter', 'Latex');
        xlabel("$$n_2$$", 'Interpreter', 'Latex');
        ylabel("$$\frac{A_2}{A_1}$$", 'Interpreter', 'Latex');
        zlabel("$$\beta_{A, cutoff}$$", 'Interpreter', 'Latex');
        hold on;
        drawnow
        hold off;
    end
end

return