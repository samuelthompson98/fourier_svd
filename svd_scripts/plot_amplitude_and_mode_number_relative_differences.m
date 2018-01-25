function plot_amplitude_and_mode_number_relative_differences(times, spectrogram, get_frequency, correct_amplitude, correct_n)
    %WRITE DOCUMENTATION
    %Extend to general numbers of modes
    %amplitude_factor = 1.57656e-3;
    amplitude_factor = 0.066
    
    frequencies = get_frequency(times);
    
    %Setup for plotting of uncertainties
    Nhr = 1e+4; 
    dr  = 1/(Nhr-1);
    load n2f_gauss.mat pdf2_norm pdf1_norm
    pdf1_norm = pdf_poly(pdf1_norm);
    pdf2_norm = pdf_poly(pdf2_norm);
    pdf2_norm.hrbin = 0 : dr : 1;
    pdf2_norm.hFr     = interp1(pdf2_norm.rbin, pdf1_norm.Fr, pdf2_norm.hrbin,'spline','extrap');
    
    Nha = 1e+4;
    da  = (max(pdf2_norm.abin) - min(pdf2_norm.abin))/(Nha-1);
    pdf2_norm.habin   = min(pdf2_norm.abin) : da : max(pdf2_norm.abin);
    pdf2_norm.hFa     = interp1(pdf2_norm.abin, pdf2_norm.Fa, pdf2_norm.habin,'spline');
    
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
    tolerance = 1e-5;
    
    for i = 1:size(times)
        [mode_object] = nmode(spectrogram, times(i), 2, 500, 100e+3); %Adjust these parameters maybe
        mode_object = nmode_filter(mode_object);
        load ../Bnoise_rms.mat Bnoise
        mode_object.a_rms = interp1(Bnoise.f, Bnoise.a_rms, mode_object.f, 'linear','extrap');
        
        Nf = length(mode_object.f);
        mode_object.FdF(1:Nf) = interp1(pdf2_norm.rbin, pdf2_norm.Fr, abs(mode_object.dF(1:Nf)),'spline','extrap');
        mode_object.Fda(1:Nf,1) = 1 - interp1(pdf2_norm.habin, pdf2_norm.hFa, abs(mode_object.a(1:Nf,1))./mode_object.a_rms ,'v5cubic',1e-5);
        mode_object.Fda(1:Nf,2) = 1 - interp1(pdf2_norm.habin, pdf2_norm.hFa, abs(mode_object.a(1:Nf,2))./mode_object.a_rms ,'v5cubic',1e-5);

        i_erange = find((mode_object.Fda(:,1) < tolerance)|isnan(mode_object.Fda(:,1)));
        mode_object.Fda(i_erange,1) = tolerance;
        i_erange = find((mode_object.Fda(:,2) < tolerance)|isnan(mode_object.Fda(:,2)));
        mode_object.Fda(i_erange,2) = tolerance;
        
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
    
    %%{
    fig1 = figure;
    plot(times, relative_amplitude_differences)
    title("Relative amplitude differences")
    xlabel("Time")
    ylabel("Relative amplitude difference")
    %%}
    fig2 = figure;
    plot(times, relative_n_differences)
    title("Relative n differences")
    xlabel("Time")
    ylabel("Relative n difference")
    %plot(times, relative_n2_differences)
return