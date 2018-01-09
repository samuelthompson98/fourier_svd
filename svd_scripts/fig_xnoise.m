
clear all

load 9425_xmd.mat xmd
ymd  = xmd;

load MC_9425_pdfs.mat data_out spectra_out fit_pdf

% perform fitting for coil 1 only
winl       = 4096;
tcoil      = 1;
Ncoils     = 3;
NZ         = 107;

tmin       = 0.239;
tmax       = 0.35;
imin       = min(find(xmd.omt(tcoil).signal(:,1)>tmin))
imax       = max(find(xmd.omt(tcoil).signal(:,1)<tmax))

ymd.omt(tcoil).signal(1:imax-imin+1,1) = xmd.omt(tcoil).signal(imin:imax,1); 
ymd.omt(tcoil).signal(1:imax-imin+1,2) = xmd.omt(tcoil).signal(imin:imax,2); 

figure; hold off;

% compute error bars
data_show = 1;

for i=1:NZ
    
    for j=1:winl
      yfit(j) = ymd.omt(1).signal((i-1)*winl+j,2);
    end;
    
    ypdf = form_pdf(yfit);
    temp = stats(ypdf)
    ypdf(:,2) = ypdf(:,2)/temp.int(2);
    
    % mag_F.mean(i) = temp.mu(2);
    % mag_F.std(i)  = temp.sd(2);
    % Fpdf(:,2)     = Fpdf(:,2)/temp.int(2);
 
    if data_show
        plot(data_out.IPx(:,1), data_out.IPx(:,2),'k.', 'MarkerSize',6); hold on;
        plot(ypdf(:,1), ypdf(:,2));
        % plot([mag_F.mean(i), mag_F.mean(i)], [min(Fpdf(:,2)), max(Fpdf(:,2))],'r'); 
        % plot([mag_s.mean(i), mag_s.mean(i)], [min(Spdf(:,2)), max(Spdf(:,2))],'g'); 
        title(['# slice = ',num2str(i)]);
        axis([0.00 0.04 0 1000]);
        set(gca,'YScale','log');
        pause; hold off;
    end 
end;

return
