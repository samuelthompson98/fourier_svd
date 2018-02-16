function plot_cutoff_amplitude3(nvals, amplitude_ratios, ...
    cutoff_amplitude, n1, j, label)
    title1 = "$$\beta_{";
    title2 = "_";
    title3 = int2str(j);
    title4 =  ", cutoff}$$ vs. $$A_1$$ and $$n_1$$";
    graph_title = strcat(title1, label, title2, title3, title4);
    
    if j == 1
        ztitle = "$$\log \left( \frac{\beta}{A_1} \right)$$"
    else
        ztitle = "$$\log \left( \beta \right)$$"
    end
    
    zvals = cutoff_amplitude(:, :, j);
    xvals = nvals .* ones(1, size(zvals, 2));
    yvals = amplitude_ratios' .* ones(size(zvals, 1), 1);
    if j == 1
        zvals = zvals ./ yvals;
    end
    for i = 1:size(zvals, 1)
        for j = 1:size(zvals, 2)
            if zvals(i, j) < 1e-4
                zvals(i, j) = 1e-4;
            end
        end
    end
    zvals = log10(zvals);
        
    f1 = figure;
    h = heatmap(nvals, amplitude_ratios, zvals');
    h.Colormap = jet(64);
    h.ColorLimits = [-4 1.5];
    %h.XLabel = "$$n_1$$";
    %h.YLabel = "$$A_1$$";
    get(h);
    
    f2 = figure;
    surf(xvals, yvals, zvals);
    view(2);
    set(gca, 'YScale', 'log');
    %set(gca, 'ZScale', 'log');
    %title(graph_title, 'Interpreter', 'Latex', 'fontsize', 20);
    xlabel("$$n_1$$", 'Interpreter', 'Latex', 'fontsize', 20);
    ylabel(ztitle, 'Interpreter', 'Latex', 'fontsize', 20);
    c = jet(64);
    cb = colorbar;
    ylabel(cb, ztitle, 'Interpreter', 'Latex', 'fontsize', 20);
    %zlabel(ztitle, 'Interpreter', 'Latex', 'fontsize', 20);
end