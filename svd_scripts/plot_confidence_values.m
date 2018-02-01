function plot_confidence_values(mode_object, fnorm)
    %Plots the values C_r and C_beta included found in "mode_object" 
    %against frequency
    
    %{
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
    %}
    
    plot_value(mode_object.f / fnorm, abs(mode_object.FdF), ...
        "Frequency", "$$C_r$$", "", @semilogy, "latex");
    plot_value(mode_object.f / fnorm, abs(mode_object.Fda(:, 1)), ...
        "Frequency", "$$1 - C_{\beta, 1}$$", "", @semilogy, "latex");
    plot_value(mode_object.f / fnorm, abs(mode_object.Fda(:, 2)), ...
        "Frequency", "$$1 - C_{\beta, 2}$$", "", @semilogy, "latex");

    %{
    figure;
    hr  = semilogy(mode_object.f(1:index) / fnorm, abs(mode_object.FdF(1:index)), residue);
    xlabel("Frequency", 'FontSize', 24);
    ylabel("$$C_r$$", 'Interpreter', 'latex', 'FontSize', 24);
    figure;
    ha1 = semilogy(mode_object.f(1:index) / fnorm, abs(mode_object.Fda(1:index, 1)), amp1);
    xlabel("Frequency", 'FontSize', 24);
    ylabel("$$1 - C_{\beta, 1}$$", 'Interpreter', 'latex', 'FontSize', 24);
    figure;
    ha2 = semilogy(mode_object.f(1:index) / fnorm, abs(mode_object.Fda(1:index, 2)), amp2);
    xlabel("Frequency", 'FontSize', 24);
    ylabel("$$1 - C_{\beta, 2}$$", 'Interpreter', 'latex', 'FontSize', 24);
    %}
return