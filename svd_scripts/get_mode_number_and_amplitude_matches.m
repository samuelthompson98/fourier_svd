function [n_matches, A_matches] = get_mode_number_and_amplitude_matches(...
        time_series, noise_amplitude, ...
        mode_crossing_time, A, n, amplitude_tolerance)
    %WRITE DOCUMENTATION
    
    f2 = 6e+4;
    num_modes = size(n, 1);
    get_frequency = @(t) f2;
    
    for i = 1:3
        time_series(i).signal(:,2) = A(1) ...
            * cos(time_series(i).signal(:,1) ...
            * 2 * pi * f2 + n(1) * time_series(i).phi );
        time_series(i).signal(:,2) = time_series(i).signal(:,2) + ...
            A(2) * cos(time_series(i).signal(:,1) * 2 * pi * f2 + ...
            n(2) * time_series(i).phi );
    end
    
    delta_n = zeros(size(noise_amplitude, 1), num_modes);
    delta_A = zeros(size(noise_amplitude, 1), num_modes);
    
    for i = 1:size(noise_amplitude)
        [this_delta_n, this_delta_A] = ...
            get_mode_number_and_amplitude_difference(time_series, ...
            noise_amplitude(i), mode_crossing_time, ...
            get_frequency, n, A, num_modes);
        delta_n(i, :) = this_delta_n;
        delta_A(i, :) = this_delta_A;
    end
    
    n_matches = delta_n == 0;
    A_matches = delta_A < amplitude_tolerance;
return