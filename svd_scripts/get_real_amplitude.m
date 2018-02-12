function real_amplitude = get_real_amplitude(initial_amplitude, frequency)

    %{
    coefficient = 2.09e6;
    power = 3.01;
    omega = 7.67612e-5;
    
    real_amplitude = initial_amplitude * (frequency .^ power) ...
        ./ (coefficient * abs(sin(omega * frequency)));
    %}

    model_c = 16.4089;
    model_omega = 1.40005;
    model_phi = -0.504286;
    model_a = 0.88319;
    model_p = 1.00588;
    
    real_amplitude = initial_amplitude * (frequency .^ model_p) / ...
        (model_c + model_a * cos(model_omega * frequency + model_phi));
return