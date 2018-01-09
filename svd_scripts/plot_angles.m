function plot_angles( x )

figure

Nx = length(x);
rho= ones(Nx,1);
rho= rho'
h= polar(x,rho,'x')

set(h,'Color','k')
set(h,'MarkerSize',16)
set(h,'MarkerFaceColor','k')
set(h,'LineWidth',2)
end

