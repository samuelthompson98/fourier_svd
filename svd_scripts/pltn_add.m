function [hfig] = pltn_add(hfig, X)

% plots eigen-mode amplitudes and residue as a fn. of freq
% Matthew Hole Jan. 2002 
% plot n mode number versus frequency

h0 = hfig(1);
h1 = hfig(2);
h2 = hfig(3);
h3 = hfig(4);
hb = hfig(5);


figure(h0);

subplot(h1); hold on;

full = 0;
if full
    text(X.con_f, abs(X.con_a), ['n = ',num2str(X.con_n)], 'FontSize',14);
    plot(X.mag_f, abs(X.mag_a), 'kx');
    plot(X.con_f, abs(X.con_a), 'k+');
else
    text(X.con_f, abs(X.con_a), ['n = ',num2str(X.con_n)], 'FontSize',14);
end;
    
return;

