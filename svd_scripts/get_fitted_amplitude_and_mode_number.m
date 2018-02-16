function [fitted_amplitude, fitted_n] = get_fitted_amplitude_and_mode_number(mode_object, frequencies, i, amplitude_factor, num_modes)
    frequency = frequencies(i)
    frequency_differences = abs(frequency - mode_object.f);
    index = find(frequency_differences == min(frequency_differences))
       
    for j = 1:num_modes
        fitted_amplitude(j) = abs(mode_object.a(index, j)) * amplitude_factor * frequency;
        fitted_n(j) = mode_object.n(max(index, 1), j);%mean(mode_object.n(max((index - 1):(index + 1), 1), j))
    end
return