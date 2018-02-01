function plot_value(xvals, yvals, xtitle, ytitle, graph_title, ...
    plot_type, interpreter)
    %Plots "yvals" against "xvals", with labels "xtitle" and "ytitle"
    %respectively on the x- and y-axes and title "graph_title. "plot_type"
    %is the function used to produce the graph ("semilogy", "loglog",
    %"plot" etc.) and "interpreter" the interpreter for the labels and
    %title ("latex", "none" etc.)

    figure;
    plot_type(xvals, yvals);
    title(graph_title, 'Interpreter', interpreter, 'FontSize', 16);
    xlabel(xtitle, 'Interpreter', interpreter, 'FontSize', 24);
    ylabel(ytitle, 'Interpreter', interpreter, 'FontSize', 24);
return