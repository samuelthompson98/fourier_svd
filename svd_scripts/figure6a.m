% MJH 12/10/05
% Plot cdfs F(r) for M=1, M=2, mock data (uniform and gaussian pdfs) and plasma noise
% Plot cdfs F(r|n) for M=1, M=2, mock data (uniform and gaussian pdfs) and plasma noise

function figure6

% load uniform_noise.mat pdf1 pdf2
load noise.mat pdf1_unfrm pdf2_unfrm pdf1_gauss pdf2_gauss pdf1_data pdf2_data

% uniform noise -------------------------------------------
pdf1 = pdf1_unfrm;
pdf2 = pdf2_unfrm;

R1bins= length(pdf1.rbin);
N1bins= length(pdf2.nbin);

R2bins= length(pdf2.rbin);
N2bins= length(pdf2.nbin);

% plot pdfs P(r) vs. r together for M=1, M=2

pdf1.Frn = pdf1.Fnr.';
pdf1.Prn = pdf1.Pnr.';
pdf2.Frn = pdf2.Fnr.';
pdf2.Prn = pdf2.Pnr.';

% adjust for endpoints
pdf1.Frn(:,1)      = 2*pdf1.Frn(:,1)
pdf1.Frn(:,N1bins) = 2*pdf1.Frn(:,N1bins)
pdf2.Frn(:,1)      = 2*pdf2.Frn(:,1)
pdf2.Frn(:,N2bins) = 2*pdf2.Frn(:,N2bins)

% normalize
pdf1.Frn = pdf1.Frn/sum(pdf1.Frn(R1bins,1:N1bins))
pdf2.Frn = pdf2.Frn/sum(pdf2.Frn(R2bins,1:N2bins))


h = figure;
fs = 14;  % font size
lw = 1.5; % line width
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

ha = subplot('Position',[0.15 0.7 0.7 0.3]);
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

hb = subplot('Position',[0.15 0.4 0.7 0.3]);
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

hc = subplot('Position',[0.15 0.1 0.7 0.3]);
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

subplot(ha);

ltype(1).Color     = 'k';
ltype(1).LineWidth = 2;
ltype(1).Marker = 'None';
ltype(1).MarkerFaceColor = 'k';
ltype(2) = ltype(1);
ltype(3) = ltype(1);
ltype(4) = ltype(1);

ltype(1).LineStyle = '-';
ltype(2).LineStyle = '--';
ltype(3).LineStyle = ':';
ltype(4).LineStyle = '-.';

% make cluster map ------------------------------------------------
cluster = 0
if cluster

    
    pdf = pdf1;
    Nc = (N1bins - 1)/2;

    Nrmesh = 50;
    NFmesh = 1000;
    [rmesh, Fmesh] = meshgrid(0:1/(Nrmesh-1):1, 0:0.12/(NFmesh-1):0.12);

    % search up/down Fmesh - and trigger Fmesh change.
    Nrmesh = size(rmesh,2)
    NFmesh = size(Fmesh,1)
    for i=1:Nrmesh
        kloc = 0;
        iloc = min(find(rmesh(1,i) <= pdf.rbin));
        [junk,index] = sort(pdf.Frn(iloc,:));
        

        for j=1:NFmesh
             
         % if in range, allocate Flus~=0 
         if (Fmesh(j,i) >  min(pdf.Frn(iloc,:)))&(Fmesh(j,i) <  max(pdf.Frn(iloc,:)))&(kloc<2*Nc+1)
            if (Fmesh(j,i) >= pdf.Frn(iloc,index(kloc+1)))
                kloc       = kloc + 1;
            end
            Fclus(j,i) = cmap(kloc,Nc);          
            
         elseif (Fmesh(j,i) >  min(pdf.Frn(iloc,:)))&(Fmesh(j,i) <  max(pdf.Frn(iloc,:)))&(kloc==2*Nc+1)
            Fclus(j,i) = cmap(kloc,Nc);               
         else            
            Fclus(j,i) = 1.0;
         end
        
        end; % j     
    end; % i
    
    hold on;
    [C,h] = contourf(rmesh, Fmesh, Fclus); 
    for i=1:length(h) set(h(i),'LineStyle','none'); end;
    colormap('gray');
    
end;

hold on;

% make fill map ------------------------------------------------
fill = 1
if fill
    
   % Plot M=2 ===================================================================================
    pdf = pdf2;
    Rbins= R2bins
    Nbins= N2bins
    Nc = (Nbins - 1)/2;

    [junk,index] = sort(pdf.Frn(fix(Rbins/2),:));
    disp(['M=2 unfrm noise ordering : ']);
    pdf.nbin(index)

    for k=1:2*Nc
        for j=1:Rbins
           pdf.Fr_poly(k,j,1)         = pdf.rbin(1,j);
           pdf.Fr_poly(k,j,2)         = min([pdf.Frn(j,index(k)) pdf.Frn(j,index(k+1))]);
           pdf.Fr_poly(k, Rbins+j,1)  = pdf.rbin(1,Rbins+1-j);
           pdf.Fr_poly(k, Rbins+j,2)  = max([pdf.Frn(Rbins+1-j,index(k)) pdf.Frn(Rbins+1-j,index(k+1))]);
       end;
       rgb = [cmap(k,Nc) cmap(k,Nc) cmap(k,Nc)];
       patch(pdf.Fr_poly(k,:,1), pdf.Fr_poly(k,:,2),rgb,'LineStyle','None');
   end;

    % Plot M=1 ===================================================================================
    pdf = pdf1;
    Rbins= R1bins
    Nbins= N1bins
    Nc = (Nbins - 1)/2;

    [junk,index] = sort(pdf.Frn(fix(Rbins/2),:));
    disp(['M=1 unfrm noise ordering : ']);
    pdf.nbin(index)

    for k=1:2*Nc
        for j=1:Rbins
           pdf.Fr_poly(k,j,1)         = pdf.rbin(1,j);
           pdf.Fr_poly(k,j,2)         = min([pdf.Frn(j,index(k)) pdf.Frn(j,index(k+1))]);
           pdf.Fr_poly(k, Rbins+j,1)  = pdf.rbin(1,Rbins+1-j);
           pdf.Fr_poly(k, Rbins+j,2)  = max([pdf.Frn(Rbins+1-j,index(k)) pdf.Frn(Rbins+1-j,index(k+1))]);
       end;
       rgb = [cmap(k,Nc) cmap(k,Nc) cmap(k,Nc)];
       patch(pdf.Fr_poly(k,:,1), pdf.Fr_poly(k,:,2),rgb,'LineStyle','None');
   end;
      
end;

axis([0 1 0 0.12]);
set(gca,'XTick',[0, 0.2, 0.4, 0.6, 0.8, 1.0],'XTickLabels',{})
set(gca,'YTick',[0, 0.05, 0.1])
ylabel(['F(r|n)']);


% gaussian noise -------------------------------------------
subplot(hb)

pdf1 = pdf1_gauss;
pdf2 = pdf2_gauss;

R1bins= length(pdf1.rbin);
N1bins= length(pdf2.nbin);

R2bins= length(pdf2.rbin);
N2bins= length(pdf2.nbin);

% plot pdfs P(r) vs. r together for M=1, M=2

pdf1.Frn = pdf1.Fnr.';
pdf1.Prn = pdf1.Pnr.';
pdf2.Frn = pdf2.Fnr.';
pdf2.Prn = pdf2.Pnr.';

% adjust for endpoints
pdf1.Frn(:,1)      = 2*pdf1.Frn(:,1)
pdf1.Frn(:,N1bins) = 2*pdf1.Frn(:,N1bins)
pdf2.Frn(:,1)      = 2*pdf2.Frn(:,1)
pdf2.Frn(:,N2bins) = 2*pdf2.Frn(:,N2bins)

% normalize
pdf1.Frn = pdf1.Frn/sum(pdf1.Frn(R1bins,1:N1bins))
pdf2.Frn = pdf2.Frn/sum(pdf2.Frn(R2bins,1:N2bins))

if fill
    
   % Plot M=2 ===================================================================================
    pdf = pdf2;
    Rbins= R2bins
    Nbins= N2bins
    Nc = (Nbins - 1)/2;

    [junk,index] = sort(pdf.Frn(fix(Rbins/2),:));
    disp(['M=2 gauss noise ordering : ']);
    pdf.nbin(index)

    for k=1:2*Nc
        for j=1:Rbins
           pdf.Fr_poly(k,j,1)         = pdf.rbin(1,j);
           pdf.Fr_poly(k,j,2)         = min([pdf.Frn(j,index(k)) pdf.Frn(j,index(k+1))]);
           pdf.Fr_poly(k, Rbins+j,1)  = pdf.rbin(1,Rbins+1-j);
           pdf.Fr_poly(k, Rbins+j,2)  = max([pdf.Frn(Rbins+1-j,index(k)) pdf.Frn(Rbins+1-j,index(k+1))]);
       end;
       rgb = [cmap(k,Nc) cmap(k,Nc) cmap(k,Nc)];
       patch(pdf.Fr_poly(k,:,1), pdf.Fr_poly(k,:,2),rgb,'LineStyle','None');
   end;

    % Plot M=1 ===================================================================================
    pdf = pdf1;
    Rbins= R1bins
    Nbins= N1bins
    Nc = (Nbins - 1)/2;

    [junk,index] = sort(pdf.Frn(fix(Rbins/2),:));
    disp(['M=1 gauss noise ordering : ']);
    pdf.nbin(index)

    for k=1:2*Nc
        for j=1:Rbins
           pdf.Fr_poly(k,j,1)         = pdf.rbin(1,j);
           pdf.Fr_poly(k,j,2)         = min([pdf.Frn(j,index(k)) pdf.Frn(j,index(k+1))]);
           pdf.Fr_poly(k, Rbins+j,1)  = pdf.rbin(1,Rbins+1-j);
           pdf.Fr_poly(k, Rbins+j,2)  = max([pdf.Frn(Rbins+1-j,index(k)) pdf.Frn(Rbins+1-j,index(k+1))]);
       end;
       rgb = [cmap(k,Nc) cmap(k,Nc) cmap(k,Nc)];
       patch(pdf.Fr_poly(k,:,1), pdf.Fr_poly(k,:,2),rgb,'LineStyle','None');
   end;
      
end;
axis([0 1 0 0.12]);
set(gca,'XTick',[0, 0.2, 0.4, 0.6, 0.8, 1.0],'XTickLabels',{})
set(gca,'YTick',[0, 0.05, 0.1])
ylabel(['F(r|n)']);


% data noise -------------------------------------------
subplot(hc)

pdf1 = pdf1_data;
pdf2 = pdf2_data;

R1bins= length(pdf1.rbin);
N1bins= length(pdf2.nbin);

R2bins= length(pdf2.rbin);
N2bins= length(pdf2.nbin);

% plot pdfs P(r) vs. r together for M=1, M=2

pdf1.Frn = pdf1.Fnr.';
pdf1.Prn = pdf1.Pnr.';
pdf2.Frn = pdf2.Fnr.';
pdf2.Prn = pdf2.Pnr.';

% adjust for endpoints
pdf1.Frn(:,1)      = 2*pdf1.Frn(:,1)
pdf1.Frn(:,N1bins) = 2*pdf1.Frn(:,N1bins)
pdf2.Frn(:,1)      = 2*pdf2.Frn(:,1)
pdf2.Frn(:,N2bins) = 2*pdf2.Frn(:,N2bins)

% normalize
pdf1.Frn = pdf1.Frn/sum(pdf1.Frn(R1bins,1:N1bins))
pdf2.Frn = pdf2.Frn/sum(pdf2.Frn(R2bins,1:N2bins))

if fill
    
   % Plot M=2 ===================================================================================
    pdf = pdf2;
    Rbins= R2bins
    Nbins= N2bins
    Nc = (Nbins - 1)/2;

    [junk,index] = sort(pdf.Frn(fix(Rbins/2),:));
    disp(['M=2 data noise ordering : ']);
    pdf.nbin(index)

    for k=1:2*Nc
        for j=1:Rbins
           pdf.Fr_poly(k,j,1)         = pdf.rbin(1,j);
           pdf.Fr_poly(k,j,2)         = min([pdf.Frn(j,index(k)) pdf.Frn(j,index(k+1))]);
           pdf.Fr_poly(k, Rbins+j,1)  = pdf.rbin(1,Rbins+1-j);
           pdf.Fr_poly(k, Rbins+j,2)  = max([pdf.Frn(Rbins+1-j,index(k)) pdf.Frn(Rbins+1-j,index(k+1))]);
       end;
       rgb = [cmap(k,Nc) cmap(k,Nc) cmap(k,Nc)];
       patch(pdf.Fr_poly(k,:,1), pdf.Fr_poly(k,:,2),rgb,'LineStyle','None');
   end;

    % Plot M=1 ===================================================================================
    pdf = pdf1;
    Rbins= R1bins
    Nbins= N1bins
    Nc = (Nbins - 1)/2;

    [junk,index] = sort(pdf.Frn(fix(Rbins/2),:));
    disp(['M=1 data noise ordering : ']);
    pdf.nbin(index)

    for k=1:2*Nc
        for j=1:Rbins
           pdf.Fr_poly(k,j,1)         = pdf.rbin(1,j);
           pdf.Fr_poly(k,j,2)         = min([pdf.Frn(j,index(k)) pdf.Frn(j,index(k+1))]);
           pdf.Fr_poly(k, Rbins+j,1)  = pdf.rbin(1,Rbins+1-j);
           pdf.Fr_poly(k, Rbins+j,2)  = max([pdf.Frn(Rbins+1-j,index(k)) pdf.Frn(Rbins+1-j,index(k+1))]);
       end;
       rgb = [cmap(k,Nc) cmap(k,Nc) cmap(k,Nc)];
       patch(pdf.Fr_poly(k,:,1), pdf.Fr_poly(k,:,2),rgb,'LineStyle','None');
   end;
      
end;
xlabel(['r']);
ylabel(['F(r|n)']);

axis([0 1 0 0.12]);
set(gca,'XTick',[0, 0.2, 0.4, 0.6, 0.8, 1.0])
set(gca,'YTick',[0, 0.05, 0.1])



return

function [z]= cmap(k,Nc)

eps = 0.1;
if k<=Nc
    z = (1-eps)* k/Nc ;
else
    z = (1-eps)*(2 - k/Nc) ;
end;

% disp(['cmap: k, z = ', num2str(k), ', ', num2str(z)]);
z = 1-eps - abs(z);
return;