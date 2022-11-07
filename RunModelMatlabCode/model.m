function xdot = model(t,y,Z,pars)

global BPo Tm lag

%----------------------------------Lags------------------------------------
ylag1 = Z(:,1); %only one lag ~1.75. NO is dependent on TNF and IL10 at
%t-1.75 hours
%---------------------------------States-----------------------------------
tnf   = y(1);
il10  = y(2);
cxcl8 = y(3);
il6   = y(4);
ma    = y(5);
mr    = y(6);
pe    = y(7);
temp2 = y(8);
pp    = y(9);
Vla   = y(10);
Vsa   = y(11);
Vlv   = y(12);
Vsv   = y(13);
hr    = y(14);
no    = y(15);
rs    = y(16);

%------------------------Inflammatory Model RHS----------------------------
%-------------------------------Parameters---------------------------------
k10    = pars(1);   k10m   = pars(2);   k6     = pars(3);
k6m    = pars(4);   k8     = pars(5);   k8m    = pars(6);
ktnf   = pars(7);   ktnfm  = pars(8);   kma    = pars(9);
kmpe   = pars(10);  kmr    = pars(11);  kpe    = pars(12);
x610   = pars(13);	x66    = pars(14);  x6tnf  = pars(15);
x810   = pars(16);	x8tnf  = pars(17);  x106   = pars(18);
xtnf10 = pars(19);  xtnf6  = pars(20);  xmpe   = pars(21);
xm10   = pars(22);  xmtnf  = pars(23);  h106   = pars(24);
h6tnf  = pars(25);  h66    = pars(26);  h610   = pars(27);
h8tnf  = pars(28);  h810   = pars(29);  htnf10 = pars(30);
htnf6  = pars(31);  hm10   = pars(32);  hmtnf  = pars(33);
hmpe   = pars(34);  stnf   = pars(35);  s10    = pars(36);
s8     = pars(37);  s6     = pars(38);  sm     = pars(39);
mmax   = pars(40);  k6tnf  = pars(41);  k8tnf  = pars(42);
k106   = pars(43);  kmtnf  = pars(44);

%----------------------------State Equations-------------------------------
dtnf   = ktnfm*ma*fs(il10,xtnf10,htnf10)*fs(il6,xtnf6,htnf6) - ktnf*(tnf - stnf);
dil10  = ma*(k10m + k106*f(il6,x106,h106)) - k10*(il10 - s10);
dil8   = ma*(k8m + k8tnf*f(tnf,x8tnf,h8tnf))*fs(il10,x810,h810) - k8*(cxcl8 - s8);
dil6   = ma*(k6m + k6tnf*f(tnf,x6tnf,h6tnf))*fs(il6,x66,h66)*fs(il10,x610,h610) - k6*(il6 - s6);
dma    = (f(pe,xmpe,hmpe))*(sm + kmtnf*f(tnf,xmtnf,hmtnf)*(xmtnf)^hmtnf)*fs(il10,xm10,hm10)*mr - kma*ma;
dmr    = kmr*mr*(1-(mr/mmax)) - (f(pe,xmpe,hmpe))*(sm + kmtnf*f(tnf,xmtnf,hmtnf)*(xmtnf)^hmtnf)*fs(il10,xm10,hm10)*mr;
dpe    = -kpe*pe;

xdot = [dtnf; dil10; dil8; dil6; dma; dmr; dpe];

%----------------------------Temperature RHS-------------------------------
%-------------------------------Parameters---------------------------------
tau1  = pars(45); TM    = pars(46); Tm    = pars(47); kt    = pars(48);
kttnf = pars(49); kt6   = pars(50); kt10  = pars(51); xttnf = pars(52);
xt6   = pars(53); xt10  = pars(54); httnf = pars(55); ht6   = pars(56);
ht10  = pars(57);

F      = kt*(TM-Tm)*((kttnf*f((abs(tnf-stnf)),xttnf,httnf) + kt6*f((abs(il6 - s6)),xt6,ht6)) - kt10*(1-fs((abs(il10-s10)),xt10,ht10))) + Tm;
dtemp2 = ((-temp2 + F)/tau1);

xdot   = [xdot; dtemp2];

%---------------------------Pain Perception RHS----------------------------
%-------------------------------Parameters---------------------------------
ppM   = pars(64); kpepp = pars(65); kpp   = pars(66);
dpp   = -kpepp*pe*pp + kpp*(ppM-pp);

xdot = [xdot; dpp];

%----------------------------Cardio Model  RHS-----------------------------
%-------------------------------Parameters---------------------------------
Ra  = pars(67);
Rv  = pars(68);
Rs  = pars(69);
Cla = pars(70);
Csa = pars(71);
Clv = pars(72);
Csv = pars(73);
Em  = pars(74);
EM  = pars(75);

% Calculate pressures (stressed volume only!)
pla  = Vla/Cla;
psa  = Vsa/Csa;
plv  = Vlv/Clv;
psv  = Vsv/Csv;

%Calculate flows
qa = (pla - psa)/Ra;
qs = (psa - psv)/rs;
qv = (psv - plv)/Rv;

Vstr = -(pla/EM - plv/Em);
Q    = Vstr*hr/60;

xdot = [xdot; Q - qa; qa - qs; qv - Q;  qs - qv];

%-----------------------------Heart Rate RHS-------------------------------
%-------------------------------Parameters---------------------------------

tau2  = pars(58); HM    = pars(59); Hm    = pars(60); kh    = pars(61);
xht   = pars(62); hht   = pars(63); xhp = pars(87);   hhp = pars(88);

ft = kh*(HM - Hm)*((((abs(temp2 - Tm))^hht/((abs(temp2 - Tm))^hht + (abs(xht - Tm))^hht)))^1)*((((abs(xhp - BPo))      ^hhp/((abs((Vla/Cla) - BPo))^hhp + (abs(xhp - BPo))^hhp)))^1) + Hm;

if (Vla/Cla) > 100
    ft = kh*(HM - Hm)*((((abs(temp2 - Tm))^hht/((abs(temp2 - Tm))^hht + (abs(xht - Tm))^hht)))^1)*((((abs(xhp - BPo))      ^hhp/((abs((Vla/Cla) - BPo))^hhp + (abs(xhp - BPo))^hhp)))^1) + Hm;
end
if (Vla/Cla) <= 100
    ft = kh*(HM - Hm)*((((abs(temp2 - Tm))^hht/((abs(temp2 - Tm))^hht + (abs(xht - Tm))^hht)))^1)*((((abs((Vla/Cla) - BPo))^hhp/((abs((Vla/Cla) - BPo))^hhp + (abs(xhp - BPo))^hhp)))^1) + Hm;
end

xdot = [xdot; (-hr + ft)/tau2];


%----------------------------Nitric Oxide RHS------------------------------
%-------------------------------Parameters---------------------------------
knom  = pars(76); kno  = pars(77);  xntnf = pars(78); xn10  = pars(79);
hntnf = pars(80); hn10 = pars(81);

dno   = knom*ma*f(ylag1(1),xntnf,hntnf)*fs(ylag1(2),xn10,hn10) - kno*no;

lag = [lag; t f(ylag1(1),xntnf,hntnf) fs(ylag1(2),xn10,hn10) f(ylag1(1),xntnf,hntnf)*fs(ylag1(2),xn10,hn10)];


xdot = [xdot; dno];

%-----------------------------Resistance RHS-------------------------------
%-------------------------------Parameters---------------------------------
krpp  = pars(82); krno = pars(83);  kr    = pars(84); xrpp  = pars(85);
hrpp  = pars(86);

drs   = krpp*(dpp^hrpp/(dpp^hrpp + xrpp^hrpp)) - krno*no - kr*(rs - Rs);

xdot = [xdot; drs];


function [y] = fs(v,x,hill)
y = x^hill/(v^hill + x^hill);

function [y] = f(v,x,hill)
y  = v^hill/(v^hill + x^hill);


