addpath svd_scripts
load struc_xmd.mat

dt   = 5.0e-7; % 0.5 mus
tmax = 5.0e-3;
for i = 1:3
    xmd.omt(i).signal(:,1) = 0:dt:tmax;
end

noise_amplitude = 10 .^ (-3:0.5:5)';
mode_crossing_time = tmax / 2;
n1 = 11; %Mode 2 is the larger mode
n2 = 6;
n = [n2; n1];
num_modes = size(n, 1);
amplitude_ratios = 10 .^ (0:0.5:2)';
num_ratios = size(amplitude_ratios, 1);
n_cutoff_amplitude = zeros(num_ratios, num_modes);
A_cutoff_amplitude = zeros(num_ratios, num_modes);
num_trials = 5;
correct_trials_required = num_trials - 1;
amplitude_tolerance = 0.05;

for i = 1:num_ratios
    [this_n_cutoff_amplitude, this_A_cutoff_amplitude] = ...
        get_cutoff_noise_amplitude2(...
        xmd.omt, noise_amplitude, amplitude_ratios(i), ...
        mode_crossing_time, n, amplitude_tolerance, ...
        num_trials, correct_trials_required);
    for j = 1:num_modes
        n_cutoff_amplitude(i, j) = ...
            this_n_cutoff_amplitude(j);
        A_cutoff_amplitude(i, j) = ...
            this_A_cutoff_amplitude(j);
    end
end

n1
n2
disp("n cutoff")
log10(n_cutoff_amplitude)
disp("a cutoff")
log10(A_cutoff_amplitude)

return