function plot_amplitude_and_mode_number_relative_differences(times, spectrogram, get_frequency, correct_amplitude, correct_n, num_modes)
    %WRITE DOCUMENTATION
    %amplitude_factor = 1.57656e-3;
    amplitude_factor = 0.066
    fnorm = 1e+3;
    
    frequencies = get_frequency(times);
    
    for i = 1:size(times)
        %Adjust these parameters maybe
        [mode_object] = get_FdF_and_Fda(spectrogram, times(i), num_modes);%(mode_object);
        
        %%{
        plot_confidence_values(mode_object, fnorm)
        mode_object.shot = 9429
        [ mode_object_noise ]  = fit_mag_power3( mode_object)
        pltn_M2data(mode_object, mode_object_noise);
        %%}
        
        frequency = frequencies(i)
        frequency_differences = abs(frequency - mode_object.f);
        index = find(frequency_differences == min(frequency_differences))
       
        for j = 1:num_modes
            fitted_amplitude(i, j) = abs(mode_object.a(index, j)) * amplitude_factor * frequency;
            fitted_n(i, j) = mode_object.n(max(index, 1), j);%mean(mode_object.n(max((index - 1):(index + 1), 1), j))
        end
    end
    
    relative_amplitude_differences = fitted_amplitude / correct_amplitude - 1;
    relative_n_differences = fitted_n / correct_n - 1;
    
    plot_amplitude_and_mode_number_relative_differences_inner(times, relative_amplitude_differences, relative_n_differences);
return