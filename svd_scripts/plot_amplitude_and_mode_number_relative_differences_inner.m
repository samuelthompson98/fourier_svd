function plot_amplitude_and_mode_number_relative_differences_inner(times, relative_amplitude_differences, relative_n_differences)
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