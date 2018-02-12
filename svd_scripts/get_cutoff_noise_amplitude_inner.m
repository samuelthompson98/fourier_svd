function cutoff = get_cutoff_noise_amplitude_inner(matches, ...
    correct_trials_required, noise_amplitudes)
    %WRITE DOCUMENTATION
    
    num_modes = size(matches, 2);
    cutoff = zeros(num_modes, 1);
    for i = 1:num_modes
        faulty_indices = find(matches(:, i) < correct_trials_required);
        if size(faulty_indices, 2) == 0
            cutoff(i) = noise_amplitudes(end);
        else
            first_faulty_index = min(faulty_indices);
            if first_faulty_index == 1
                cutoff(i) = 0;
            else
                cutoff(i) = noise_amplitudes(first_faulty_index - 1);
            end
        end
    end
    
    
return;