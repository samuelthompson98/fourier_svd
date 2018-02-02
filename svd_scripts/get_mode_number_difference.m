function [delta_n] = get_mode_number_difference(time_series, ...
        noise_amplitude, mode_crossing_time, get_frequency, n, num_modes)
    %WRITE DOCUMENTATION
    
    Nx = size(time_series(1).signal,1);
    B = [0.049922035 -0.095993537 0.050612699 -0.004408786];
    A = [1.0 -2.494956002   2.017265875  -0.522189400];
    nT60 = round(log(1000)/(1-max(abs(roots(A))))); % T60 est.

    for i=1:3
        v = randn(1,Nx+nT60); % Gaussian white noise: N(0,1)
        x = filter(B,A,v);    % Apply 1/F roll-off to PSD
        x = x(nT60+1:end);    % Skip transient response
        time_series(i).signal(:,2) = time_series(i).signal(:,2) ... 
            + noise_amplitude * x';
    end

    window_length    = 2048;
    norm    = spec_norm(window_length);
    spectrogram = spec(time_series, window_length, norm);
    
    [mode_object] = nmode(spectrogram, ...
        mode_crossing_time, num_modes, 500, 100e+3);
    mode_object = nmode_filter(mode_object);
    
    frequency = get_frequency(mode_crossing_time);
    frequency_index = find_index_of_closest(mode_object.f, frequency);
    
    delta_n = (mode_object.n(frequency_index, :))' - n;
return