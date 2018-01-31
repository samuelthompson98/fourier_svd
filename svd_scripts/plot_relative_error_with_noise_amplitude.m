function [confidence_object] = plot_relative_error_with_noise_amplitude(omt, beta, get_frequencies, amplitude, mode_number, num_modes, mode_crossing_time)
    %WRITE DOCUMENTATION

    Nx = size(omt(1).signal,1);
    B = [0.049922035 -0.095993537 0.050612699 -0.004408786];
    A = [1.0 -2.494956002   2.017265875  -0.522189400];
    nT60 = round(log(1000)/(1-max(abs(roots(A))))); % T60 est.

    for i=1:3
        v = randn(1,Nx+nT60); % Gaussian white noise: N(0,1)
        x = filter(B,A,v);    % Apply 1/F roll-off to PSD
        x = x(nT60+1:end);    % Skip transient response
        omt(i).signal(:,2) = omt(i).signal(:,2) + beta * x';
    end

    winl    = 2048;
    norm    = spec_norm(winl);
    spectrogram = spec(omt, winl, norm);

    %{
    tnorm = 1e-3
    fnorm = 1e+3
    %This function gives an error - had to change some content
    render_example(spectrogram(1), tnorm, fnorm) %Figure 1

    it = min(find(spectrogram(1).t >= 0.25)) %0.165
    figure
    semilogy(spectrogram(1).f, abs(spectrogram(1).F(:,it))) %Figure 2
    %}

    toff   = min(omt(1).signal(:,1));
    
    %get_frequencies1 = @(t) 2 * f1 * t;
    %get_frequencies2 = @(t) f2 * ones(size(t))
    %get_frequencies3 = @(t) f3 * (1 - 2 * t)
    times = 0.0:0.1:0.29
    
    [mode_object] = get_FdF_and_Fda(spectrogram, mode_crossing_time, num_modes);
    fnorm = 1e+3;
    %plot_confidence_values(mode_object, fnorm)
    %{
    mode_object.shot = 9429
    [ mode_object_noise ]  = fit_mag_power3( mode_object)
    pltn_M2data(mode_object, mode_object_noise);
    %}
    
    for i = 1:size(get_frequencies)
        get_frequency = get_frequencies{i};
        [rmsd_object] = plot_amplitude_and_mode_number_relative_differences(times', spectrogram, get_frequency, amplitude(i), mode_number(i), i, num_modes, beta);
        frequency = get_frequency(mode_crossing_time);
        index = find_index_of_closest(mode_object.f, frequency)
        FdF(i) = abs(mode_object.FdF(index));
        Fda(i) = abs(mode_object.Fda(index, i));
        a(i) = abs(mode_object.a(index, i));
        rmsd_amplitude(i) = rmsd_object.amplitude(i);
        rmsd_n(i) = rmsd_object.n(i);
    end
   
    confidence_object = struct('FdF', FdF, 'Fda', Fda, 'a', a, 'rmsd_amplitude', rmsd_amplitude, 'rmsd_n', rmsd_n);
return