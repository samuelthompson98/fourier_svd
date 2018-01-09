function [result]=mtype(n)

n0.MarkerFaceColor='m';
n0.MarkerSize=4;
n0.Marker='o';
n0.LineStyle = 'none';

np1=n0; np2=n0; np3=n0;
np4=n0; np5=n0; np6=n0; npp=n0;
np1.MarkerFaceColor='k';
np2.MarkerFaceColor='b';
np3.MarkerFaceColor='r';
np4.MarkerFaceColor='g';
np5.MarkerFaceColor='y';
np6.MarkerFaceColor='c';
npp.MarkerFaceColor='m';
npp.Marker='o';


nn1=np1; nn2=np2; nn3=np3;
nn4=np4; nn5=np5; nn6=np6; nnn=npp;
nn1.Marker='s';
nn2.Marker='s';
nn3.Marker='s';
nn4.Marker='s';
nn5.Marker='s';
nn6.Marker='s';
nnn.Marker='s';

switch n
     case 0, result=n0;
     case 1, result=np1;
     case 2, result=np2;
     case 3, result=np3;
     case 4, result=np4;
     case 5, result=np5;
     case 6, result=np6;
     % case 7, result=np1;
     % case 8, result=np2;
     % case 9, result=np3;
     % case 10, result=np4;
     % case 11, result=np5;
         
     case -1, result=nn1;
     case -2, result=nn2;
     case -3, result=nn3;
     case -4, result=nn4;
     case -5, result=nn5;
     case -6, result=nn6;
     % case -7, result=nn1;
     % case -8, result=nn2;
     % case -9, result=nn3;
     % case -10, result=nn4;
     % case -11, result=nn5;

end;
if n < -6 ; result=nnn; end;
if n > +6 ; result=npp; end;


return;
