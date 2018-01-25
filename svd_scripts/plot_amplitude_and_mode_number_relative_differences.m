function plot_amplitude_and_mode_number_relative_differences(times, spectrogram, get_frequency, correct_amplitude, correct_n)
    %WRITE DOCUMENTATION
    %Extend to general numbers of modes
    %amplitude_factor = 1.57656e-3;
    amplitude_factor = 0.066
    
    frequencies = get_frequency(times);
    
    residue.MarkerFaceColor ='k';
    residue.MarkerSize      = 1;
    residue.Marker          ='none';
    residue.LineStyle       = '-';
    residue.Color           = 'k';
    residue.LineWidth       = 1.5;  
    
    amp1.Marker          ='none';
    amp1.LineStyle       = '--';
    amp1.Color           = 'k';
    amp1.LineWidth       = 1.5;

    amp2.Marker          ='none';
    amp2.LineStyle       = ':';
    amp2.Color           = 'k';
    amp2.LineWidth       = 1.5;
    
    fnorm = 1e+3;
    
    for i = 1:size(times)
        [mode_object] = nmode(spectrogram, times(i), 2, 500, 100e+3); %Adjust these parameters maybe
        mode_object = nmode_filter(mode_object);
        mode_object = get_FdF_and_Fda(mode_object);
        
        fig3 = figure;
        hr  = semilogy(mode_object.f / fnorm, mode_object.FdF, residue);
        hold on;
        ha1 = semilogy(mode_object.f / fnorm, mode_object.Fda(:, 1), amp1); 
        ha2 = semilogy(mode_object.f / fnorm, mode_object.Fda(:, 2), amp2); 
        hold off;
        %%{
        mode_object.shot = 9429
        [ mode_object_noise ]  = fit_mag_power3( mode_object)
        pltn_M2data(mode_object, mode_object_noise);
        %%}
        
        frequency = frequencies(i)
        frequency_differences = abs(frequency - mode_object.f);
        index = find(frequency_differences == min(frequency_differences))
       
        for j = 1:size(mode_object.a, 2)
            fitted_amplitude(i, j) = abs(mode_object.a(index, j)) * amplitude_factor * frequency;
            fitted_n(i, j) = mode_object.n(max(index, 1), j);%mean(mode_object.n(max((index - 1):(index + 1), 1), j))
        end
    end
    
    relative_amplitude_differences = fitted_amplitude / correct_amplitude - 1;
    relative_n_differences = fitted_n / correct_n - 1;
    
    fig1 = figure;
    plot(times, relative_amplitude_differences)
    title("Relative amplitude differences")
    xlabel("Time")
    ylabel("Relative amplitude difference")
    fig2 = figure;
    plot(times, relative_n_differences)
    title("Relative n differences")
    xlabel("Time")
    ylabel("Relative n difference")
return