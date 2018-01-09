% pre-allocation
NS = NP;
stoke_pdf.IPI = zeros(NS, 2);
stoke_pdf.IPQ = zeros(NS, 2);
stoke_pdf.IPU = zeros(NS, 2);
stoke_pdf.IPV = zeros(NS, 2);
stoke_pdf.IPVpos = zeros(NS, 2);
stoke_pdf.IPVneg = zeros(NS, 2);
stoke_pdf.IPUpos = zeros(NS, 2);
stoke_pdf.IPUneg = zeros(NS, 2);
stoke_pdf.IPQpos = zeros(NS, 2);
stoke_pdf.IPQneg = zeros(NS, 2);

% MJH 15/12/03: change NSlog from 100 to NP
NSlog  = NP;

stoke_pdf.IPlogI = zeros(NSlog, 2);
stoke_pdf.IPI1   = zeros(NSlog, 2);
stoke_pdf.IPlogrl= zeros(NSlog, 2);
stoke_pdf.IPrl1  = zeros(NSlog, 2);

stoke_pdf.IPlogVpos = zeros(NSlog, 2);
stoke_pdf.IPlogVneg = zeros(NSlog, 2);
stoke_pdf.IPVpos1   = zeros(NSlog, 2);
stoke_pdf.IPVneg1   = zeros(NSlog, 2);

stoke_pdf.IPlogvpos = zeros(NSlog, 2);
stoke_pdf.IPlogvneg = zeros(NSlog, 2);
stoke_pdf.IPvpos1   = zeros(NSlog, 2);
stoke_pdf.IPvneg1   = zeros(NSlog, 2);
stoke_pdf.IPvpos    = zeros(NSlog, 2);
stoke_pdf.IPvneg    = zeros(NSlog, 2);

stoke_pdf.IPlogUpos = zeros(NSlog, 2);
stoke_pdf.IPlogUneg = zeros(NSlog, 2);
stoke_pdf.IPUpos1   = zeros(NSlog, 2);
stoke_pdf.IPUneg1   = zeros(NSlog, 2);

stoke_pdf.IPlogQpos = zeros(NSlog, 2);
stoke_pdf.IPlogQneg = zeros(NSlog, 2);
stoke_pdf.IPQpos1   = zeros(NSlog, 2);
stoke_pdf.IPQneg1   = zeros(NSlog, 2);

stoke_pdf.IPv  = zeros(NS, 2);
stoke_pdf.IPu  = zeros(NS, 2);
stoke_pdf.IPq  = zeros(NS, 2);
stoke_pdf.IPrl = zeros(NS, 2);

% form x-axis for I
Imin = exp(pdf_lims.logI(1));
Imax = exp(pdf_lims.logI(2));
dI   = (Imax-Imin)/(NS-1);
dlogI= (log(Imax)-log(Imin))/(NSlog-1);
stoke_pdf.IPI(:,1)    = Imin:dI:Imax; 
stoke_pdf.IPlogI(:,1) = log(Imin):dlogI:log(Imax); 

% form x-axis for V
Vmin = min([ exp(pdf_lims.logVpos(1)) exp(pdf_lims.logVneg(1))]);
Vmax = max([ exp(pdf_lims.logVpos(2)) exp(pdf_lims.logVneg(2))]);
dlogV= (log(Vmax)-log(Vmin))/(NSlog-1);
stoke_pdf.IPV(:,1)    = -Vmax:2*Vmax/(NS-1):Vmax; 
stoke_pdf.IPVpos(:,1) = Vmin:(Vmax-Vmin)/(NS-1):Vmax; 
stoke_pdf.IPVneg(:,1) = -Vmax:(Vmax-Vmin)/(NS-1):-Vmin; 
stoke_pdf.IPlogVpos(:,1) = log(Vmin):dlogV:log(Vmax); 
stoke_pdf.IPlogVneg(:,1) = log(Vmin):dlogV:log(Vmax); 

% form x-axis for U
Umin = min([ exp(pdf_lims.logUpos(1)) exp(pdf_lims.logUneg(1))]);
Umax = max([ exp(pdf_lims.logUpos(2)) exp(pdf_lims.logUneg(2))]);
dlogU= (log(Umax)-log(Umin))/(NSlog-1);
stoke_pdf.IPU(:,1)    = -Umax:2*Umax/(NS-1):Umax; 
stoke_pdf.IPUpos(:,1) = Umin:(Umax-Umin)/(NS-1):Umax; 
stoke_pdf.IPUneg(:,1) = -Umax:(Umax-Umin)/(NS-1):-Umin; 
stoke_pdf.IPlogUpos(:,1) = log(Umin):dlogU:log(Umax); 
stoke_pdf.IPlogUneg(:,1) = log(Umin):dlogU:log(Umax); 

% form x-axis for Q
Qmin = min([ exp(pdf_lims.logQpos(1)) exp(pdf_lims.logQneg(1))]);
Qmax = max([ exp(pdf_lims.logQpos(2)) exp(pdf_lims.logQneg(2))]);
dlogQ= (log(Qmax)-log(Qmin))/(NSlog-1);
stoke_pdf.IPQ(:,1)    = -Qmax:2*Qmax/(NS-1):Qmax; 
stoke_pdf.IPQpos(:,1) = Qmin:(Qmax-Qmin)/(NS-1):Qmax; 
stoke_pdf.IPQneg(:,1) = -Qmax:(Qmax-Qmin)/(NS-1):-Qmin; 
stoke_pdf.IPlogQpos(:,1) = log(Qmin):dlogQ:log(Qmax); 
stoke_pdf.IPlogQneg(:,1) = log(Qmin):dlogQ:log(Qmax); 

% form x-axis for v 
vmin = 0.0+eps;
vmax = +1;
dlogv= (log(vmax)-log(vmin))/(NSlog-1);
stoke_pdf.IPv(:,1)       = -vmax:2*vmax/(NS-1):vmax; 
stoke_pdf.IPvpos(:,1)    = 0:(vmax-0)/(NS-1):vmax; 
stoke_pdf.IPvneg(:,1)    = -vmax:(vmax-0)/(NS-1):-0; 
stoke_pdf.IPlogvpos(:,1) = log(vmin):dlogv:log(vmax); 
stoke_pdf.IPlogvneg(:,1) = log(vmin):dlogv:log(vmax); 

% form x-axis for u,q 
umax = 1.0;
qmax = 1.0;
stoke_pdf.IPu(:,1)       = -umax:2*umax/(NS-1):umax; 
stoke_pdf.IPq(:,1)       = -qmax:2*qmax/(NS-1):qmax; 

% form x-axis for rl
rlmin = 0+eps;
rlmax = 1;
dlogrl= (log(rlmax)-log(rlmin))/(NSlog-1);
stoke_pdf.IPrl(:,1)   = 0:rlmax/(NS-1):rlmax; 
stoke_pdf.IPlogrl(:,1) = log(rlmin):dlogrl:log(rlmax); 

% size of arrays
stoke_pdf.NX = NX;
stoke_pdf.NP = NP;
