addpath svd_scripts
load struc_xmd.mat

dt   = 5.0e-7; % 0.5 mus
tmax = 5.0e-3;
for i = 1:3
    xmd.omt(i).signal(:,1) = 0:dt:tmax;
end

n = [15; -5];
A = [5; 1];
%f1 = 15e+4; %Linearly increasing frequency
f2 = 6e+4; %Constant frequency

for i = 1:3
    %xmd.omt(i).signal(:,2) = A(1) * cos(xmd.omt(i).signal(:,1) .^ 2 ...
    %    * 2 * pi * f1 + n(1) * xmd.omt(i).phi ); 
    xmd.omt(i).signal(:,2) = A(1) * ...
        cos(xmd.omt(i).signal(:,1) * 2 * pi * f2 + n(1) * xmd.omt(i).phi );
    xmd.omt(i).signal(:,2) = xmd.omt(i).signal(:,2) + A(2) * ...
        cos(xmd.omt(i).signal(:,1) * 2 * pi * f2 + n(2) * xmd.omt(i).phi );
end

noise_amplitude = (0:10:50)';
get_frequency = @(t) f2;
mode_crossing_time = tmax / 2;
num_modes = 2;
delta_n = zeros(size(noise_amplitude, 1), num_modes);

for i = 1:size(noise_amplitude)
    delta_n(i, :) = get_mode_number_difference(xmd.omt, ...
        noise_amplitude(i), mode_crossing_time, ...
        get_frequency, n, num_modes);
end

for i = 1:size(n)
    plot_value(noise_amplitude, delta_n(:, i), "$$\beta$$", ...
        "$$\Delta n$$", "$$\Delta n$$ vs. $$\beta$$", @plot, 'latex');
end

return