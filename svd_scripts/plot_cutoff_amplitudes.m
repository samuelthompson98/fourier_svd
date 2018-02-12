function plot_cutoff_amplitudes(nvals, amplitude_ratios, ...
    cutoff_amplitude, i, j, label)
    title1 = "$$\beta_{";
    title2 = ...
        ", cutoff}$$ vs. $$\frac{A_1}{A_2}$$ and $$n_2$$ for $$n_1 =$$";
    title3 = int2str(nvals(i));
    title4 = " and mode number ";
    title5 = int2str(j);
    graph_title = strcat(title1, label, title2, title3, title4, title5);
    
    ztitle1 = "$$\beta_{";
    ztitle2 = ", cutoff}$$";
    ztitle = strcat(ztitle1, label, ztitle2);
    
    zvals = cutoff_amplitude(:, :, i, j);
    xvals = nvals .* ones(1, size(zvals, 2));
    yvals = amplitude_ratios' .* ones(size(zvals, 1), 1);
        
    figure;
    surf(xvals, yvals, zvals);
    set(gca, 'YScale', 'log');
    set(gca, 'ZScale', 'log');
    title(graph_title, 'Interpreter', 'Latex', 'fontsize', 20);
    xlabel("$$n_2$$", 'Interpreter', 'Latex', 'fontsize', 20);
    ylabel("$$\frac{A_2}{A_1}$$", 'Interpreter', ...
    	'Latex', 'fontsize', 20);
    zlabel(ztitle, 'Interpreter', 'Latex', 'fontsize', 20);
end