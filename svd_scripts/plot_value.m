function plot_value(xvals, yvals, xtitle, ytitle, graph_title, plot_type, interpreter)
    figure;
    plot_type(xvals, yvals);
    title(graph_title, 'Interpreter', interpreter, 'FontSize', 16)
    xlabel(xtitle, 'Interpreter', interpreter, 'FontSize', 24);
    ylabel(ytitle, 'Interpreter', interpreter, 'FontSize', 24);
return