
function freq(X,f)
[junk,Ncoils] = size(X)

tx  = X(1).t;
fx  = X(1).f;

f_index = max(find(fx<f))

figure;
hold on;

subplot(2,1,1);
hold on;
Fmax=0;
for i=1:Ncoils
  plot(tx,abs(X(i).F(f_index,:)));
pause(0.1);

  Fmax= max([Fmax max(abs(X(i).F(f_index,:)))])
end;

Fmax

subplot(2,1,2);
hold on;
for i=1:Ncoils
  plot(tx,angle(X(i).F(f_index,:)));
end;

hold off;

return;
