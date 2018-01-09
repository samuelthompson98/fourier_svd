% ==========================================================
function X=fild_spec(x, varargin)

% calculates specotrgam of specified shot and items
%
% Matthew Hole, Jan 2002
% All data of form 
% (coil,i,1)=time
% (coil,i,2)=data

[Nstruct, Ncoils, Nx] = size(x);

% h=figure;

for i=1:Ncoils
  if x(i).data
    disp([' Forming spectrum of i = ',num2str(i)]);
    xin(:,:)  = x(i).signal(:,:);
    X(i).data = 1;
    if isfield(x(i),'phi')   X(i).phi  = x(i).phi;  end;
    if isempty(varargin)
       [X(i).F, X(i).f, X(i).t, X(i).dt, X(i).df] = fild_getspec(xin,1);
    elseif (size(varargin,2)==1)
       winl = varargin{1};    
       [X(i).F, X(i).f, X(i).t, X(i).dt, X(i).df] = fild_getspec(xin,1, winl);
    elseif  (size(varargin,2)==2)  
       winl = varargin{1};    
       norm = varargin{2};
       [X(i).F, X(i).f, X(i).t, X(i).dt, X(i).df] = fild_getspec(xin,1, winl, norm);
    elseif (size(varargin,2)==3)  
       winl = varargin{1};    
       norm = varargin{2};
       test = varargin{3};
       [X(i).F, X(i).f, X(i).t, X(i).dt, X(i).df] = fild_getspec(xin,1, winl, norm, test);        
    elseif (size(varargin,2)==5)  
       winl = varargin{1};    
       norm = varargin{2};
       test = varargin{3};
       flow = varargin{4};
       fhigh= varargin{5};
       [X(i).F, X(i).f, X(i).t, X(i).dt, X(i).df] = fild_getspec(xin,1, winl, norm, test, flow, fhigh)       
   end;
    
    % fix time shift
     tmin = min(xin(:,1));
     tmax = max(xin(:,1));
     ftmin= min(X(i).t);
     ftmax= max(X(i).t);
     X(i).t = X(i).t + tmin - ftmin;
     
  else
    X(i).data = 0;
  end;
end;

return;

