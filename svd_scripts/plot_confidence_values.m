function plot_confidence_values(mode_object, fnorm)
    amp1.Marker          ='none';
    amp1.Color           = 'k';
    amp1.LineWidth       = 1.5;
    amp2 = amp1
    residue = amp1
    amp1.LineStyle       = '--';
    amp2.LineStyle       = ':'
    residue.LineStyle    = '-'
    residue.MarkerFaceColor ='k';
    residue.MarkerSize      = 1;

    fig3 = figure;
    hr  = semilogy(mode_object.f / fnorm, mode_object.FdF, residue);
    hold on;
    ha1 = semilogy(mode_object.f / fnorm, mode_object.Fda(:, 1), amp1); 
    ha2 = semilogy(mode_object.f / fnorm, mode_object.Fda(:, 2), amp2); 
    hold off;
return