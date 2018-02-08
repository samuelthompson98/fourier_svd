addpath svd_scripts
load struc_xmd.mat

dt   = 5.0e-7; % 0.5 mus
tmax = 5.0e-3;
num_sensors = 3;
f = 1e4 * (2:0.2:10)';
max_height = zeros(size(f));
n1 = 10;
winl    = 2048;
norm    = spec_norm(winl);

model_coefficient = 2.09e6;
model_power = -3.01;
%model_period = 9e4;
model_omega = 7.67612e-5;
model_phase = 0;

model = model_coefficient * f .^ model_power .* ...
    abs(sin(model_omega * f + model_phase));

for i = 1:num_sensors
    xmd.omt(i).signal(:,1) = 0:dt:tmax;
end

for i = 1:size(f)
    for j = 1:num_sensors
        xmd.omt(j).signal(:,2) = cos(xmd.omt(j).signal(:,1) ...
            * 2 * pi * f(i) + n1 * xmd.omt(j).phi );
    end
    
    XMD.omt = spec(xmd.omt, winl, norm);
    [Z1] = nmode(XMD.omt, tmax / 2, 2, 500, 100e+3);
    max_height(i) = max(abs(Z1.a(:, 1)));
    disp("max height")
    disp(f(i));
    disp(max_height(i));
end

residuals = (model - max_height) / max_height;%/ max_height - 1;
figure;
hold on;
plot(f, max_height);
plot(f, model);
hold off;
figure;
plot(f, residuals);

save struc_XMD.mat XMD

return