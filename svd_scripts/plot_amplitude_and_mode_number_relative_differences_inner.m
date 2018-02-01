function plot_amplitude_and_mode_number_relative_differences_inner(...
    times, relative_amplitude_differences, relative_n_differences, ...
    beta, mode_num)

    amplitude_title1 = "Relative amplitude";
    n_title1 = "Relative n";
    title2 = num2str(beta, ...
        ' difference for beta =%10.1e and mode number ');
    title3 = int2str(mode_num);
    amplitude_title = strcat({amplitude_title1}, {title2}, {title3});
    n_title = strcat({n_title1}, {title2}, {title3});
    plot_value(times, relative_amplitude_differences, "Time", ...
        "Relative amplitude difference", amplitude_title, @plot, 'none');
    legend("Mode 1", "Mode 2");
    plot_value(times, relative_n_differences, "Time", ...
        "Relative n difference", n_title, @plot, 'none');
    legend("Mode 1", "Mode 2");
return