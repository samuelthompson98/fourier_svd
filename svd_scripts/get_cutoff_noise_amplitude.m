function [n_cutoff, A_cutoff] = get_cutoff_noise_amplitude(omt, ...
        noise_amplitude, amplitude_ratio, mode_crossing_time, n, ...
        amplitude_tolerance)
    %WRITE DOCUMENTATION
    %"amplitude_ratio": ratio of primary mode amplitude to secondary mode
    %amplitude
    
    A = [amplitude_ratio; 1];
    f2 = 6e+4;
    num_modes = size(n, 1);
    get_frequency = @(t) f2;
    
    for i = 1:3
        omt(i).signal(:,2) = A(1) * cos(omt(i).signal(:,1) ...
            * 2 * pi * f2 + n(1) * omt(i).phi );
        omt(i).signal(:,2) = omt(i).signal(:,2) + A(2) * ...
            cos(omt(i).signal(:,1) * 2 * pi * f2 + ...
            n(2) * omt(i).phi );
    end
    
    n_cutoff = zeros(num_modes, 1);
    delta_n = zeros(size(noise_amplitude, 1), num_modes);
    this_delta_n = zeros(1, num_modes);
    A_cutoff = zeros(num_modes, 1);
    delta_A = zeros(size(noise_amplitude, 1), num_modes);
    this_delta_A = zeros(1, num_modes);
    
    for i = 1:size(noise_amplitude)
        [this_delta_n, this_delta_A] = ...
            get_mode_number_and_amplitude_difference(omt, ...
            noise_amplitude(i), mode_crossing_time, ...
            get_frequency, n, A, num_modes);
        delta_n(i, :) = this_delta_n;
        delta_A(i, :) = this_delta_A;
    end
    
    for i = 1:num_modes
        j = 1;
        while ((j <= size(noise_amplitude, 1)) && (delta_n(j, i) == 0))
            j = j + 1;
        end
        
        if j > 1
            n_cutoff(i) = noise_amplitude(j - 1);
        else
            n_cutoff(i) = 0;%1e-4;
        end
        
        j = 1;
        while ((j <= size(noise_amplitude, 1)) && ...
                (delta_A(j, i) < amplitude_tolerance))
            j = j + 1;
        end
        
        if j > 1
            A_cutoff(i) = noise_amplitude(j - 1);
        else
            A_cutoff(i) = 0;%1e-4;
        end
    end
    
return