
load 9429_xmd.mat

for i=1:3
    for j=1:1000
        time(j)  = xmd.omt(i).signal(j,1);
        data(i,j)= xmd.omt(i).signal(j,2);
        
        int(i,j) = sum(xmd.omt(i).signal(1:j,2) - mean(xmd.omt(i).signal(1:j,2)));
    end
end

plot(time, data(1,:),'k-'); hold on;
plot(time, data(2,:),'r-');
plot(time, data(3,:),'b-');
