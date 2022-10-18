function [pars,Init] = load_pars_Init
global ODE_TOL

ODE_TOL  = 1e-8; 

global Tm BPo
%---------------------Inflammatory Model Parameters------------------------
%Rate Constants
k10    = 1.03876;	
k6     = 1.20757;       
k8     = 0.87956;	
ktnf   = 0.92019;

kma    = 2.51;	
kmpe   = 4.14E-06;	
kmr    = 0.006;    
kpe    = 1.44958;    

k10m   = 0.01644;	
k6m    = 0.19074;        
k8m    = 0.27149;    
ktnfm  = 0.75478; 

%Saturation Constants
x610   = 34.7720;	
x810   = 17.3860;    
xtnf10 = 17.3860;   
xm10   = 4.3465;  
x66    = 560;        
x106   = 560;        
xtnf6  = 560; 
x6tnf  = 185;        
x8tnf  = 185;        
xmtnf  = 100;             
xmpe   = 3.3;     

%Exponents
h106   = 3.675;      
h6tnf  = 2;     
h66    = 1;	
h610   = 4;      
h8tnf  = 3;        
h810   = 1.5;        
htnf10 = 3;     
htnf6  = 2;	
hm10   = 0.3;	
hmtnf  = 3.160;	 
hmpe   = 1; 

k6tnf  = 0.8100;           
k8tnf  = 0.5600;
k106   = 0.0191; 
kmtnf  = 4.14e-06;

% Source Terms & MRmax  
stnf   = 1.05;        
s10    = 0.22;   
s8     = 3.54;	
s6     = 0.85; 	
sm     = 0.0414;        
mmax   = 30000;

%----------------------------Initial Conditions----------------------------
tnfI   =  1.05; 
il10I  = 0.22; 
il8I   = 3.54;  
il6I   = 0.85;
maI    = 0.0;   
mrI    = 28200; 
peI    = 2.0;   
tempI  = 36.5; 

Init = [tnfI il10I il8I il6I maI mrI peI]; 

%-----------------------Temperature equation parameters--------------------
tau1   = 0.87171; 
kt     = 0.5; 
TM     = 39.5;      
Tm     = tempI;
kttnf  = 1.5;    
xttnf  = 185;     
httnf  = 0.75;
kt6    = 0.76730;    
xt6    = 560;     
ht6    = 0.75;
kt10   = 0.0625; 
xt10   = 34.7720; 
ht10   = 1;

%-----------------------Temperature Initial Condition--------------------
Init = [Init tempI];

%------------------------Pain Perception Threshold pars--------------------
kpepp  = 0.46811; 
kpp    = 0.17568; 
ppM    = 1334; 

Init = [Init ppM];

%---------------------Cardiovascular Model Parameters----------------------
% Height, weight and gender used to predict blood volume
H      = 191;   % Subject height cm
W      = 80.2;  % Subject weight kg
Gender = 1;     % Male 1, female 2

% Define body surface area, used to predict blood volume
BSA = sqrt(H*W/3600);  % Body surface area

% Prediction of patient specific blood volume and cardiac output
if Gender == 2
  TotalVol = (3.47*BSA - 1.954)*1000; % Female ml/min
elseif Gender == 1
  TotalVol = (3.29*BSA - 1.229)*1000; % Male ml/min
end;
qtot = TotalVol/60;     % Assume blood circulates in one min ml/sec
CO   = TotalVol/1000;   % l/sec

% Flows (related to subject)
qa  = qtot;        % Arteries --> arteries in organ bed
qs  = qtot;        % Arteries in organ bed --> veins in organ bed
qv  = qtot;        % Veins in organ bed --> veins

% Pressures (related to subject) 
pla = 122-12.94012; % data.BP(1)=122 Organ bed systolic arterial pressure
psa = pla*.95;      % Arterial systolic pressure (ideally should come from data!)
psv = 3.75;         % Organ bed veins
plv = 3.5;          % Venous pressure

% Resistances (Ohm's law)
Ra  = 0.06106604766; %Ra=(pla - psa)/qa Arteries --> organ bed arteries
Rv  = 0.00269903513; %Rv=(psv - plv)/qv Organ bed veins --> veins
Rs  = 1.26977203816; %Rs=(psa - psv)/qs Arteries in organ bed --> veins in organ bed

% Volume distribution (Beneken and deWit)
VtotS = TotalVol;       % Systemic volume is 85% of total volume 
VtotA = 0.20*VtotS;     % Arterial volume is 20% of systemic volume
VtotV = 0.80*VtotS;     % Venous volume is 80% of systemic volume

VlaT  = VtotA*0.85;
VsaT  = VtotA*0.15;
VlvT  = VtotV*0.15;
VsvT  = VtotV*0.85;

VlaS   = VlaT*0.18;
VsaS   = VsaT*0.18;
VlvS   = VlvT*0.05;
VsvS   = VsvT*0.05;
VStot  = VlaS + VlvS + VsaS + VsvS;

Vun    = 10;

% Compliances, stressed volume percentages from Beneken are weighted averages (Beneken and deWit)
Cla = VlaS/pla;      % Artery compliance (stressed to total volume arteries ~25%)
Clv = 9.52721416516; % Clv=VlvS/plv Venous compliance (stressed to total volume veins ~7%)
Csa = 0.27924898093; % Csa=VsaS/psa Organ bed artery compliance 
Csv = 50.38837714017;% Csv=VsvS/psv Organ bed venous compliance

% Parameters needed to set up information within the heart (Olufsen and Williams non-puls)
Vun  = 10;		    % Unstressed ventricular volume
Ved  = 142 - Vun;  	% Maximum ventricular volume (volume at end of filling), can we make this patient specific?
Ves  = 47  - Vun;
Em   = 0.026515;    % Em=plv/Ved; Minimum elasticity of the heart [ pv / (Ved - Vun) ]
EM   = 3.05745;     % EM=pla/Ves;

HI = 72.51997; % data.HR(1)=72.51997
hr = HI/60;

VT= VStot;
VlaI = (Ra*hr + Rs*hr + Rv*hr + Em)*Cla*EM*VT/(Cla*EM*Ra*hr + Cla*EM*Rs*hr + Cla*EM*Rv*hr + Clv*Em*Ra*hr + Clv*Em*Rs*hr + Clv*Em*Rv*hr + Csa*EM*Rs*hr + Csa*EM*Rv*hr + Csa*Em*Ra*hr + Csv*EM*Rv*hr + Csv*Em*Ra*hr + Csv*Em*Rs*hr + Cla*EM*Em + Clv*EM*Em + Csa*EM*Em + Csv*EM*Em);
VlvI = Clv*Em*VT*(Ra*hr + Rs*hr + Rv*hr + EM)/(Cla*EM*Ra*hr + Cla*EM*Rs*hr + Cla*EM*Rv*hr + Clv*Em*Ra*hr + Clv*Em*Rs*hr + Clv*Em*Rv*hr + Csa*EM*Rs*hr + Csa*EM*Rv*hr + Csa*Em*Ra*hr + Csv*EM*Rv*hr + Csv*Em*Ra*hr + Csv*Em*Rs*hr + Cla*EM*Em + Clv*EM*Em + Csa*EM*Em + Csv*EM*Em);
VsvI = Csv*VT*(EM*Rv*hr + Em*Ra*hr + Em*Rs*hr + EM*Em)/(Cla*EM*Ra*hr + Cla*EM*Rs*hr + Cla*EM*Rv*hr + Clv*Em*Ra*hr + Clv*Em*Rs*hr + Clv*Em*Rv*hr + Csa*EM*Rs*hr + Csa*EM*Rv*hr + Csa*Em*Ra*hr + Csv*EM*Rv*hr + Csv*Em*Ra*hr + Csv*Em*Rs*hr + Cla*EM*Em + Clv*EM*Em + Csa*EM*Em + Csv*EM*Em);
VsaI = VT-VlaI-VsvI-VlvI;


% Start the system in steady state
Init = [Init VlaI VsaI VlvI VsvI];

BPo = 122; % data.BP(1)=122
%------------------------Heart rate equation parameters--------------------
HM = 190.41; %data.HM=207 - 0.7*(data.age),  data.age=23.7
kh = 0.18276;  
tau2 = 0.34; 
xhp = 143; 
xht = 36.55;
hht = 2; 
hhp = 4; 

Init = [Init HI];

%------------------Nitric oxide equation parameters------------------------
knom  = 0.002; 
kno   = 0.045; 
xntnf = 130;    
hntnf = 2; 
xn10  = 4; 
hn10  = 0.4;

noI   = 0;
Init = [Init noI];

%-------------------Resistance equation parameters-------------------------
krpp = 3.71878; 
xrpp = 230; 
hrpp = 2;
krno = 0.5; 
kr = 2.19712; 

Init = [Init Rs];

% Parameter Vector
pars = [k10   k10m   k6    k6m   k8      k8m    ktnf  ktnfm kma    kmpe ...  %1 -10
        kmr   kpe    x610  x66   x6tnf   x810   x8tnf x106  xtnf10 xtnf6 ... %11-20
        xmpe  xm10   xmtnf h106  h6tnf   h66    h610  h8tnf h810   htnf10 ...%21-30
        htnf6 hm10   hmtnf hmpe  stnf    s10    s8    s6    sm     mmax ...  %31-40
        k6tnf k8tnf  k106  kmtnf                                        ...  %41-44 %end of inflammatory
        tau1  TM     Tm    kt    kttnf   kt6    kt10  xttnf xt6    xt10 ...  %45-54
        httnf ht6    ht10                                               ...; %55-57 %end of temperature
        tau2  HM     HI    kh    xht     hht                            ...';%58-63 %end of heart rate
        ppM   kpepp  kpp                                                ...';%64-66 %end of PPT 
        Ra    Rv     Rs    Cla    Csa    Clv     Csv   Em    EM         ...';%67-75 %end of BP
        knom  kno    xntnf xn10  hntnf   hn10                           ...';%76-81 %end of NO
        krpp  krno   kr    xrpp  hrpp    xhp    hhp                      ]';%82-86 %end of R  %%87-88 Addns in HR
