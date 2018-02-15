addpath svd_scripts
load struc_xmd.mat

dt   = 5.0e-7; % 0.5 mus
tmax = 5.0e-3;
for i = 1:3
    xmd.omt(i).signal(:,1) = 0:dt:tmax;
end

noise_amplitude = 10 .^ (-3:1:5)';
get_frequency = @(t) f2;
mode_crossing_time = tmax / 2;
n1 = 11;
nvals = (-10:10:10)';
num_modes = 2;
amplitude_ratios = 10 .^ (0:1:2)';
n_cutoff_amplitude = zeros(size(nvals, 1), size(nvals, 1), num_modes);
A_cutoff_amplitude = zeros(size(nvals, 1), size(nvals, 1), num_modes);
num_trials = 2;
correct_trials_required = num_trials - 1;
amplitude_tolerance = 0.05;

for j = 1:size(nvals)
    n = [nvals(j); n1];
    for k = 1:size(amplitude_ratios)
        [this_n_cutoff_amplitude, this_A_cutoff_amplitude] = ...
            get_cutoff_noise_amplitude2(...
            xmd.omt, noise_amplitude, amplitude_ratios(k), ...
            mode_crossing_time, n, amplitude_tolerance, ...
            num_trials, correct_trials_required);
        for l = 1:size(this_n_cutoff_amplitude)
            n_cutoff_amplitude(j, k, l) = ...
                this_n_cutoff_amplitude(l);
            A_cutoff_amplitude(j, k, l) = ...
                this_A_cutoff_amplitude(l);
        end
    end
end

for j = 1:num_modes
    plot_cutoff_amplitude2(nvals, amplitude_ratios, ...
        n_cutoff_amplitude, n1, j, "n");
    plot_cutoff_amplitude2(nvals, amplitude_ratios, ...
        A_cutoff_amplitude, n1, j, "A");
end

return