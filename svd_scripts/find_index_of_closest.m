function [index] = find_index_of_closest(array, value)
    %Finds "i" such that "array[i]" is the closest element in "array" to "value"
    
    differences = abs(array - value * ones(size(array)));
    indices = find(differences == min(differences));
    index = indices(1);
return