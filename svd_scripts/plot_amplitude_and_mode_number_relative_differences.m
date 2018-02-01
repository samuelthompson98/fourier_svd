function [rmsd_object] = ...
    plot_amplitude_and_mode_number_relative_differences(times, ...
    spectrogram, get_frequency, correct_amplitude, correct_n, ...
    mode_num, num_modes, beta, mode_crossing_time)

    %Plots the relative difference between the fitted and correct amplitude
    %and mode number of a mode with frequency a function of time given by 
    %"get_frequency" amplitude given by "correct_amplitude" and mode number
    %given by "correct_n". Returns an object containing the root mean 
    %square value of the relative differences in amplitude and mode number,
    %taken across time.
    
    %amplitude_factor = 1.57656e-3;
    amplitude_factor = 0.066;
    fnorm = 1e+3;
    
    time_index = find_index_of_closest(times, mode_crossing_time);
    frequencies = get_frequency(times);
    
    fitted_amplitude = zeros(size(times, 1), num_modes);
    fitted_n = zeros(size(times, 1), num_modes);
    
    for i = 1:size(times)
        %Adjust these parameters maybe
        [mode_object] = get_FdF_and_Fda(spectrogram, times(i), num_modes);
        
        %{
        plot_confidence_values(mode_object, fnorm)
        mode_object.shot = 9429
        [ mode_object_noise ]  = fit_mag_power3( mode_object)
        pltn_M2data(mode_object, mode_object_noise);
        %}
        
        %{
        frequency = frequencies(i)
        frequency_differences = abs(frequency - mode_object.f);
        frequency_index = find(frequency_differences == min(frequency_differences))
        %}
        frequency = frequencies(i);
        frequency_index = find_index_of_closest(mode_object.f, frequency);
       
        for j = 1:num_modes
            fitted_amplitude(i, j) = ...
                abs(mode_object.a(frequency_index, j)) ...
                * amplitude_factor * frequency;
            fitted_n(i, j) = mode_object.n(max(frequency_index, 1), j);
            %mean(mode_object.n(max((frequency_index - 1):(frequency_index + 1), 1), j))
        end
    end
    
    relative_amplitude_differences = ...
        fitted_amplitude / correct_amplitude - 1;
    relative_n_differences = fitted_n / correct_n - 1;
    
    %Will break for more than 2 modes, unless all modes cross at once
    new_relative_amplitude_differences = ...
        relative_amplitude_differences(:, 1);
    new_relative_amplitude_differences(time_index) = ...
        relative_amplitude_differences(time_index, mode_num);
    new_relative_n_differences = ...
        relative_n_differences(:, 1);
    new_relative_n_differences(time_index) = ...
        relative_n_differences(time_index, mode_num);
    
    rmsd_amplitude = sqrt(mean(new_relative_amplitude_differences .^ 2))
    rmsd_n = sqrt(mean(new_relative_n_differences .^ 2))
    
    rmsd_object = struct('amplitude', rmsd_amplitude, 'n', rmsd_n);
    
    plot_amplitude_and_mode_number_relative_differences_inner(times, ...
        relative_amplitude_differences, relative_n_differences, beta, ...
        mode_num);
return