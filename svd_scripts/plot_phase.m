
function plot_phase(Z)


X = Z;

filt.gaussian = 0;

if filt.gaussian==1
    Nf = length(Z.f);
    NM = size(Z.n, 2);

   if isfield(Z,'dtfil') 
       filt.fsigma = 0.44 / Z.dtfil *2*sqrt(2*log(2));
   else
       filt.fsigma = 1.5*1e+3;
       filt.fsigma = 200;
       filt.fsigma = 10000;
   end
   filt.df    = Z.f(2)-Z.f(1);
   sigma_n    = filt.fsigma/filt.df;
   Nw         = Nf + (1-mod(Nf,2)); % make Nw odd
   nw         = (Nw-1)/2;
   ic         = nw+1;
   for i=1:Nw
       w(i) = 1/(sqrt(2*pi)*sigma_n)*exp(-(i-ic)^2/(2* sigma_n^2));
   end;

   Zoff.dF(1:Nf)         = 0.0;
   Zoff.a(1:Nf,:)        = 0.0;
   Zoff.dF(Nf+1:2*Nf)    = Z.dF;
   Zoff.a(Nf+1:2*Nf,:)   = Z.a;
   Zoff.dF(2*Nf+1:3*Nf)  = 0.0;
   Zoff.a(2*Nf+1:3*Nf,:) = 0.0;

   for i=1:Nf
       X.dF(i)    = Zoff.dF(Nf+i-nw:Nf+i+nw) *w.' ;
       X.amag(i,:)= abs(Zoff.a(Nf+i-nw:Nf+i+nw,:)).'*w.' ;
       X.aphase(i,:)= angle(Zoff.a(Nf+i-nw:Nf+i+nw,:)).'*w.' ;
   end;

else
   X.amag   = abs(X.a);
   X.aphase	= angle(X.a);
   Nf = length(X.amag);
end

i=1;
while i<= Nf
    if (X.aphase(i,1)>pi)
        X.aphase(i,1) = X.aphase(i,1) - 2*pi;
    elseif (X.aphase(i,1)<-pi)
        X.aphase(i,1) = X.aphase(i,1) + 2*pi;
    end
    i = i+1;
end

figure
subplot(2,1,1)
plot(Z.f, X.amag)
set(gca,'YScale','log');

subplot(2,1,2)
plot(Z.f, 180/pi*X.aphase)

return

   