function [mode_object] = get_FdF_and_Fda(spectrogram, time, num_modes)
%WRITE DOCUMENTATION
    [mode_object] = nmode(spectrogram, time, num_modes, 500, 100e+3);
    mode_object = nmode_filter(mode_object);
    tolerance = 1e-5;

    Nhr = 1e+4; 
    dr  = 1/(Nhr-1);
    load n2f_gauss.mat pdf2_norm pdf1_norm
    pdf1_norm = pdf_poly(pdf1_norm);
    pdf2_norm = pdf_poly(pdf2_norm);
    pdf2_norm.hrbin = 0 : dr : 1;
    pdf2_norm.hFr     = interp1(pdf2_norm.rbin, pdf1_norm.Fr, pdf2_norm.hrbin,'spline','extrap');
    
    Nha = 1e+4;
    da  = (max(pdf2_norm.abin) - min(pdf2_norm.abin))/(Nha-1);
    pdf2_norm.habin   = min(pdf2_norm.abin) : da : max(pdf2_norm.abin);
    pdf2_norm.hFa     = interp1(pdf2_norm.abin, pdf2_norm.Fa, pdf2_norm.habin,'spline');
    
    load ../Bnoise_rms.mat Bnoise
    mode_object.a_rms = interp1(Bnoise.f, Bnoise.a_rms, mode_object.f, 'linear','extrap');
        
    Nf = length(mode_object.f);
    mode_object.FdF(1:Nf) = interp1(pdf2_norm.rbin, pdf2_norm.Fr, abs(mode_object.dF(1:Nf)),'spline','extrap');
    mode_object.Fda(1:Nf,1) = 1 - interp1(pdf2_norm.habin, pdf2_norm.hFa, abs(mode_object.a(1:Nf,1))./mode_object.a_rms ,'v5cubic',1e-5);
    mode_object.Fda(1:Nf,2) = 1 - interp1(pdf2_norm.habin, pdf2_norm.hFa, abs(mode_object.a(1:Nf,2))./mode_object.a_rms ,'v5cubic',1e-5);

    i_erange = find((mode_object.Fda(:,1) < tolerance)|isnan(mode_object.Fda(:,1)));
    mode_object.Fda(i_erange,1) = tolerance;
    i_erange = find((mode_object.Fda(:,2) < tolerance)|isnan(mode_object.Fda(:,2)));
    mode_object.Fda(i_erange,2) = tolerance;
return