addpath svd_scripts
load struc_xmd.mat

dt   = 5.0e-7; % 0.5 mus
tmax = 0.3;
num_sensors = 3;
f = 1e4 * (1.0:0.5:10)';
max_height = zeros(size(f));
n1 = (-20:1:20)';
winl    = 2048;
norm    = spec_norm(winl);
max_residual = zeros(size(n1));

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

for k = 1:size(n1)
    for i = 1:size(f)
        for j = 1:num_sensors
            xmd.omt(j).signal(:,2) = amplitude * ...
                cos(xmd.omt(j).signal(:,1) ...
                * 2 * pi * f(i) + n1(k) * xmd.omt(j).phi );
        end
    
        XMD.omt = spec(xmd.omt, winl, norm);
        [Z1] = nmode(XMD.omt, 0.165, 2, 500, 100e+3);
        Z1 = nmode_filter(Z1);
        max_height(i) = max(abs(Z1.a(:, 1)));
        residuals = abs((model - max_height) ./ max_height);
        max_residual(k) = max(residuals);
    end
end

figure;
scatter_plot = scatter(n1, max_residual);
xlabel("Mode number");%, 'fontsize', 24);
ylabel("Maximum relative error");%, 'fontsize', 24);
set(gca, 'fontsize', 16);
scatter_plot.MarkerEdgeColor = 'k';
scatter_plot.MarkerFaceColor = 'k';

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