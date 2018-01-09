function pltn1(Z)

% plots eigen-mode amplitudes and residue as a fn. of freq
% Matthew Hole Jan. 2002 
% plot n mode number versus frequency
h=figure;

h1=subplot(3,1,1); hold on;
semilogy(Z.f,abs(Z.a));
ylabel('|a|');
set(gca, 'YScale','log')

h2=subplot(3,1,2); hold on;
semilogy(Z.f,abs(Z.dF));
ylabel('residue');

h2=subplot(3,1,3); hold on;
plot(Z.f,Z.n);
ylabel('n');

return


