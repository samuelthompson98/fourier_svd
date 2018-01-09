load cc16891array2.dat


x = cc16891array2;

% construct xmd
tnorm = 0.001;
xmd.omt(1).signal(:,1) = x(:,1) * tnorm;
xmd.omt(2).signal(:,1) = x(:,1)* tnorm;
xmd.omt(3).signal(:,1) = x(:,1)* tnorm;
xmd.omt(4).signal(:,1) = x(:,1)* tnorm;

% MJH processing 15/06/07: remove mean
xmd.omt(1).signal(:,2) = cumsum(x(:,2)); 
xmd.omt(2).signal(:,2) = cumsum(x(:,3));
xmd.omt(3).signal(:,2) = cumsum(x(:,4)) ;
xmd.omt(4).signal(:,2) = cumsum(x(:,5)) ;



figure
hold on
plot(xmd.omt(1).signal(:,1), xmd.omt(1).signal(:,2),'k');
plot(xmd.omt(3).signal(:,1), xmd.omt(3).signal(:,2),'r');
plot(xmd.omt(4).signal(:,1), xmd.omt(4).signal(:,2),'b');
