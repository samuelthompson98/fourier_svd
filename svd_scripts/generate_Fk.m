
function [X] = generate_Fk(x)

% INPUT 
% x.signal(:,1) = time column
% x.signal(:,2) = data column

% OUTPUT 
% X(i).F, X(i).f, X(i).t, X(i).dt, X(i).df

set(0,'DefaultFigureVisible','off');
X = spec(x)
set(0,'DefaultFigureVisible','on');

% render(X);

return

