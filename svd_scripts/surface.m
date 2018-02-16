%{
x = ones(2, 1)
y = ones(1, 2)
x .* y
%}

%%{
[X,Y] = meshgrid(1:0.5:10,1:20)
Z = sin(X) + cos(Y)
surf(X,Y,Z)
%%}