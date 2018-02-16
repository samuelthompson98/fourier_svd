xvals = -20:1:20
yvals = [0.0180 0.0180 0.5313 0.0180 0.0180 0.5313 0.0180 0.0180 0.0180...
    0.0180 0.0180 0.5437 0.0180 0.0180 0.5486 0.0180 0.0180 0.449...
    0.0180 0.0180 0.0180 0.0180 0.0180 0.449 0.0180 0.0180 0.5486...
    0.0180 0.0180 0.5437 0.0180 0.0180 0.0180 0.0180 0.0180 0.5313 ...
    0.0180 0.0180 0.5313 0.0180 0.0180]

figure;
s = scatter(xvals, yvals);
s.MarkerEdgeColor = 'k';
s.MarkerFaceColor = 'k';
xlabel("Mode number");
ylabel("Maximum magnitude of relative error");
set(gca, 'fontsize', 16);