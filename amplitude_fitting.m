addpath svd_scripts
load struc_xmd.mat

dt   = 5.0e-7; % 0.5 mus
tmax = 0.3;
num_sensors = 3;
f = 1e4 * (1.0:0.5:10)';
max_height = zeros(size(f));
n1 = 10;
winl    = 2048;
norm    = spec_norm(winl);

%{
model_c = 15.4455;
model_a = 0.836157;
model_phi = -0.651708
model_omega = 1.4005
%}
amplitude = 5;
model_c = 16.4089;
model_omega = 1.40005;
model_phi = -0.504286;
model_a = 0.88319;
model_p = 1.00588;
model = amplitude * (model_c + model_a * ...
    cos(model_omega * f + model_phi)) ./ (f .^ model_p);

for i = 1:num_sensors
    xmd.omt(i).signal(:,1) = 0:dt:tmax;
end

for i = 1:size(f)
    for j = 1:num_sensors
        xmd.omt(j).signal(:,2) = amplitude * cos(xmd.omt(j).signal(:,1) ...
            * 2 * pi * f(i) + n1 * xmd.omt(j).phi );
    end
    
    XMD.omt = spec(xmd.omt, winl, norm);
    [Z1] = nmode(XMD.omt, 0.165, 2, 500, 100e+3);
    Z1 = nmode_filter(Z1);
    disp("max height")
    max_height(i) = max(abs(Z1.a(:, 1)));
    max_height(i)
    disp("model")
    get_real_amplitude(max_height(i), f(i))
end

fig1 = figure;
hold on;
plot2 = plot(f / 1000, max_height);
plot1 = plot(f / 1000, model);
xlabel("Frequency (kHz)");%, 'fontsize', 24);
ylabel("Amplitude");%, 'fontsize', 24);
set(gca, 'fontsize', 16);
legend('Calculated Amplitudes', 'Model');
hold off;

fig2 = figure;
residuals = (model - max_height) ./ max_height;
plot3 = plot(f / 1000, residuals);
xlabel("Frequency (kHz)");%, 'fontsize', 24);
ylabel("Relative Error");%, 'fontsize', 24);
set(gca, 'fontsize', 16);
disp("Max Residual");
max(abs(residuals))

%{
residuals = (model - max_height) ./ max_height;%/ max_height - 1;
figure;
hold on;
plot(f, max_height);
plot(f, model);
hold off;
figure;
plot(f, residuals);
%}

save struc_XMD.mat XMD

return