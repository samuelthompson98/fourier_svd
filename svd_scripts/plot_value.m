function plot_value(xvals, yvals, xtitle, ytitle, plot_type, interpreter)
    figure;
    plot_type(xvals, yvals);
    xlabel(xtitle, 'FontSize', 24);
    ylabel(ytitle, 'Interpreter', interpreter, 'FontSize', 24);
return