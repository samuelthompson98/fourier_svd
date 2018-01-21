function plot_amplitude_and_mode_number_relative_differences(times, spectrogram, get_frequency, correct_amplitude, correct_n)
    %WRITE DOCUMENTATION
    %Extend to general numbers of modes
    frequencies = get_frequency(times);
    
    relative_amplitude_differences = zeros(size(times));
    relative_n_differences = zeros(size(times));
    
    for i = 1:size(times)
        [mode_object] = nmode(spectrogram, times(i), 2, 500, 100e+3); %Adjust these parameters
        frequency = frequencies(i)
        frequency_differences = abs(frequency - mode_object.f);
        index = find(frequency_differences == min(frequency_differences))
       
        fitted_amplitude = abs(mode_object.a(index, 1));
        fitted_n = abs(mode_object.n(index, 1))
        
        relative_amplitude_differences(i) = abs(fitted_amplitude / correct_amplitude - 1);
        relative_n_differences(i) = abs(fitted_n / correct_n - 1);
    end
    
    fig = figure;
    
    %plot(times, relative_amplitude_differences)
    plot(times, relative_n_differences)
    %plot(times, relative_n2_differences)
return