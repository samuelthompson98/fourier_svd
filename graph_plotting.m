min_n = -20;
max_n = 20;
n1 = 11;

A = 10 .^ (0:0.5:2)';
n2 = cat(1, (min_n:1:(n1 - 1))', ((n1 + 1):1:max_n)');
%{
n2 = [-20 -19 -18 -17 -16 -15 -14 -13 -12 
    -10 -9 -8 -6 -5 -4 -3 -2 -1 0 ...
    1 2 3 4 5 6 7 8 9 10 12 13 14 15 16 17 18 19 20]'
%}

num_ns = size(n2, 1);
num_as = size(A, 1);
num_modes = 2;
a_cutoff = zeros(num_ns, num_as, num_modes);
n_cutoff = zeros(num_ns, num_as, num_modes);

n_cutoff(:, :, 1) = 10 .^ [-4 1.5 1 2.5 3; -4 -4 -4 -4 -4;
    -3 1 2 2 3; -4 1 1.5 2.5 3;
    -4 1.5 2 2 3.5; -4 1 2 2.5 3.5; -4 0.5 2 3 2.5; ...
    -4 -4 -4 -4 -4; -4 0.5 1.5 2.5 3.5; -4 1.5 1.5 2 3; ...
    -3 0.5 1 2.5 3; -4 1.5 2 2 3; -4 0.5 1.5 2 2.5; ...
    -4 -4 -4 -4 -4;
    -4 1 2 1 3; -3 0.5 2 2 3; -3 1.5 2.5 2 3.5; ...
    -4 0 2.5 2.5 2.5; -4 2 2 2 3; -4 -4 -4 -4 -4; ...
    -4 0.5 1.5 2.5 3;
    -4 1 2 2.5 2; -4 1.5 2.5 2 3; -3 1 1 2.5 3; ...
    -4 1 1.5 2 3; -4 -4 -4 -4 -4; -4 1 2 2.5 2.5;
    -4 1 2 3 3; -4 1 2.5 2 3; -4 0.5 1.5 1 3; ...
    -4 0.5 1.5 3 2.5; ... %11
    -4 1.5 2 2.5 2; -4 2 2 2.5 2.5; -4 1 2 2 3.5; ...
    -4 0.5 2 1.5 3;
    -4 2 1 3 3; -4 -4 -4 -4 -4; -4 1 2 2 3; ...
    -3 1.5 2 2.5 3; -4 1 1 3 3];
n_cutoff(:, :, 2) = 10 .^ [-4 1 1 1.5 1.5; -4 -4 -4 -4 -4;
    -3 1 1 1 1; -4 0.5 1.5 0.5 0.5;
    -4 1.5 1 1 1.5; -4 1 1 1 1.5; -4 0.5 1 1 1;
    -4 -3 -4 -4 -4; -4 0.5 1 1 1; -4 1 1 1 1;
    -3 0.5 0.5 0.5 0.5; -4 1 1.5 1 1.5; -4 0.5 1 1.5 1.5;
    -4 -3 -4 -3 -3;
    -4 1 1.5 1 1; -3 0.5 1 1 1; -3 1 1 1 1; -4 0 0 0 0.5;
    -4 1 1 1 1.5; -4 -4 -4 -4 -4; %0
    -4 0.5 1.5 1 1;
    -4 1 1.5 1.5 1.5; -4 1.5 1.5 1.5 1; -3 1 1 1 1.5;
    -4 0.5 0 0 0; -4 -4 -4 -4 -4; -4 1 1.5 1 1;
    -4 1 1 1.5 1.5; -4 1 1 1 1; -4 0.5 1 1 0.5; -4 0.5 1 0.5 0.5; %11
    -4 0 1.5 0.5 0.5; -4 1 1 1 1; -4 1 1.5 1 1; %15
    -4 0.5 1 1 1.5;
    -4 1 1 1 1.5; -4 -4 -4 -4 -4; -4 1 0 0.5 0; 
    -3 1 1.5 1.5 1.5; -4 1 1 1 1.5];
a_cutoff(:, :, 1) = 10 .^ [1 1 1 2.5 2.5; -4 -4 -4 -4 -4;
    -0.5 1 1.5 1.5 2.5; 0 0.5 1.5 2 2.5;
    0.5 1.5 2 2 2.5; 0.5 1 2 2.5 3; 0.5 0.5 1.5 2 2.5; ...
    -4 -4 -4 -4 -4; 0.5 0.5 1.5 2.5 3; 0.5 1 1.5 1.5 3; ...
    0 0.5 1 2 2.5; 1 1 2 2 3; 0 0.5 1.5 2 2.5; ...
    -4 -4 -4 -4 -4;
    0.5 1 2 1 2.5; 0.5 0.5 1.5 2 3; 0.5 1 1.5 2 3; ...
    0 0 0 0.5 2.5; 0.5 1 1 1.5 2.5; -4 -4 -4 -4 -4; ...
    0.5 0.5 1.5 2.5 2.5;
    1 1 2 2 2; 0.5 1.5 2 2 3; 1 1 1 2 2; 0.5 0.5 0 0.5 3; ...
    -4 -4 -4 -4 -4; 0.5 1 2 2 2.5;
    0.5 1.5 1.5 2 3; -0.5 1 2 2 3; 0.5 0.5 1 1 3; ...
    0.5 0.5 1 2 2.5; ... %11
    0.5 0 1 2.5 2; 0.5 1 1 2 2.5; 0 1 2 2 2.5; ... %15
    0.5 0.5 1.5 1.5 2.5;
    0.5 1 1 2.5 2.5; -4 -4 -4 -4 -4; 0 1 0 2 2.5; ...
    1 1 1.5 2 2.5; 0.5 1 1 2.5 3];
a_cutoff(:, :, 2) = 10 .^ [0.5 1 1 0.5 1; -4 -4 -4 -4 -4;
    -0.5 1 1 1 1; 0 1 1 0.5 0.5;
    1 1 1 1 1; 0.5 1 1 1 1; 0.5 0.5 1 1 1; -4 -4 -4 -4 -4;
    0.5 0.5 1 1 1; -4 1 1 1 1; 0 0.5 0.5 0.5 0.5;
    0.5 1 1 1 0.5; 0 1 1 1.5 1; -4 -4 -4 -4 -4;
    0.5 1 1 1 1; 0.5 0.5 1 1 1; 0.5 1 1 1 1.5; 0 0 0 0 0.5;
    0.5 1 1 0.5 1; -4 -4 -4 -4 -4;
    1 0.5 1 1 1;
    1 1 1 0.5 0.5; 0.5 1 1 0.5 1; 1 0.5 0.5 1 1; 0.5 0.5 0 0 0;
    -4 -4 -4 -4 -4; 0.5 1 1 0.5 1;
    0.5 1 1 1 1; -0.5 1 0.5 1 0.5; 0.5 0.5 0.5 1 0.5;
    0.5 0.5 0.5 0.5 0.5; %11
    0.5 0 0.5 0.5 0.5; 0.5 0.5 0.5 1 1; 0 1 0.5 1 1; %15
    0.5 0.5 0.5 1 1;
    0.5 0.5 0.5 1 1; -4 -4 -4 -4 -4; 0.5 0.5 0 0.5 0;
    1 0.5 1 1 1; 0.5 1 1 0.5 1];

%Fix this - check axes right way around
%%{
for j = 1:num_modes
    plot_cutoff_amplitude3(n2, A, n_cutoff, n1, j, "n");
    plot_cutoff_amplitude3(n2, A, a_cutoff, n1, j, "A");
end
%%}