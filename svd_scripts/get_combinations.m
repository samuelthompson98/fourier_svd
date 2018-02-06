function new_combinations = get_combinations(Nc, nsimul)
    new_combinations = ((-Nc):1:Nc)';
    
    for i = 2:nsimul
        old_combinations = new_combinations;
        new_combinations_size = 0;
        for j = 1:size(old_combinations)
            final_number = old_combinations(j, i - 1);
            num_additions = Nc - final_number;
            new_combinations_size = new_combinations_size + num_additions;
        end
        new_combinations = zeros(new_combinations_size, i);
        l = 1;
        for j = 1:size(old_combinations)
            final_number = old_combinations(j, i - 1);
            for k = (final_number + 1):Nc
                new_combinations(l, 1:(i - 1)) = old_combinations(j, :);
                new_combinations(l, i) = k;
                l = l + 1;
            end
        end
    end
return