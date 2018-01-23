function plot_amplitude_and_mode_number_relative_differences(times, spectrogram, get_frequency, correct_amplitude, correct_n)
    %WRITE DOCUMENTATION
    %Extend to general numbers of modes
    %amplitude_factor = 1.57656e-3;
    amplitude_factor = 0.066
    
    frequencies = get_frequency(times);
    
    relative_amplitude_differences = zeros(size(times));
    relative_n_differences = zeros(size(times));
    
    for i = 1:size(times)
        [mode_object] = nmode(spectrogram, times(i), 2, 500, 100e+3); %Adjust these parameters maybe
        %figg = figure;
        %plot(mode_object.f, mode_object.a(:, 1))
        
        mode_object = nmode_filter(mode_object)
        %%{
        mode_object.shot = 9429
        [ mode_object_noise ]  = fit_mag_power3( mode_object)
        pltn_M2data(mode_object, mode_object_noise);
        %%}
        
        frequency = frequencies(i)
        frequency_differences = abs(frequency - mode_object.f);
        index = find(frequency_differences == min(frequency_differences))
       
        fitted_amplitude(i) = abs(mode_object.a(index, 1)) * amplitude_factor * frequency;
        max(abs(mode_object.a(:, 1)))
        fitted_n(i) = mean(mode_object.n(max((index - 1):(index + 1), 1), 1))
    end
    
    relative_amplitude_differences = fitted_amplitude / correct_amplitude - 1;
    relative_n_differences = fitted_n / correct_n - 1;
    
    %%{
    fig1 = figure;
    plot(times, relative_amplitude_differences)
    title("Relative amplitude differences")
    %%}
    fig2 = figure;
    plot(times, relative_n_differences)
    title("Relative n differences")
    %plot(times, relative_n2_differences)
return