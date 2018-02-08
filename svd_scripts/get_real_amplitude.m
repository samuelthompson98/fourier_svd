function real_amplitude = get_real_amplitude(initial_amplitude, frequency)
    coefficient = 2.09e6;
    power = 3.01;
    omega = 7.67612e-5;
    
    real_amplitude = initial_amplitude * (frequency .^ power) ...
        ./ (coefficient * sin(omega * frequency));
return