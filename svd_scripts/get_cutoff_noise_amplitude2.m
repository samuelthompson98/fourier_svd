function [n_cutoff, A_cutoff] = get_cutoff_noise_amplitude2(time_series, ...
        noise_amplitude, amplitude_ratio, mode_crossing_time, n, ...
        amplitude_tolerance, num_trials, correct_trials_required)
    %WRITE DOCUMENTATION
    %"amplitude_ratio": ratio of primary mode amplitude to secondary mode
    %amplitude
    
    A = [amplitude_ratio; 1];
    num_modes = size(n, 1);
    
    n_matches = zeros(size(noise_amplitude, 1), num_modes);
    A_matches = zeros(size(noise_amplitude, 1), num_modes);
    
    for i = 1:num_trials
        [n_matches_inner, A_matches_inner] = ...
            get_mode_number_and_amplitude_matches(time_series, ...
            noise_amplitude, mode_crossing_time, ...
            A, n, amplitude_tolerance);
        n_matches = n_matches + n_matches_inner;
        A_matches = A_matches + A_matches_inner;
    end
    n_cutoff = get_cutoff_noise_amplitude_inner(n_matches, ...
        correct_trials_required, noise_amplitude);
    A_cutoff = get_cutoff_noise_amplitude_inner(A_matches, ...
        correct_trials_required, noise_amplitude);
return