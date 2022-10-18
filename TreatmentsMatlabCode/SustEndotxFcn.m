function SustEndotoxFcn(pars,Init,time)
% Sustained Endotoxemia
  
global SustEndotox
global intLPSadsop
global intAntipyret
global intVasopres

SustEndotox     = true;
intLPSadsop     = false;
intAntipyret    = false;
intVasopres     = false;

parsSustEndotox    = pars;
InitSustEndotox    = Init;
InitSustEndotox(7) = 1.0 * Init(7);

%%% Run simulation
[sol] = modelDriver(parsSustEndotox,time,InitSustEndotox);

%%% Computations to obtain BP
Cla  = parsSustEndotox(70);    
Vla  = sol.y(10,:);  
pla  = Vla/Cla;      

%%% Plot model simulations

% TNF
figure(1); hold on
plot(sol.x,sol.y(1,:),'k','linewidth',4)
xlim([0,time(end)])

% IL6
figure(2); hold on
plot(sol.x,sol.y(4,:),'k','linewidth',4)
xlim([0,time(end)])

% IL8
figure(3); hold on
plot(sol.x,sol.y(3,:),'k','linewidth',4)
xlim([0,time(end)])

% Temperature
figure(4); hold on
plot(sol.x,sol.y(8,:),'k','linewidth',4)
xlim([0,time(end)])

% Blood Pressure
figure(5); hold on
plot(sol.x,pla,'k','linewidth',4);
xlim([0,time(end)])

% Heart Rate
figure(6); hold on
plot(sol.x,sol.y(14,:),'k','linewidth',4)
xlim([0,time(end)])

% Vascular Resistance
figure(7); hold on
plot(sol.x,sol.y(16,:),'k','linewidth',4)
xlim([0,time(end)])

% Nitric Oxide
figure(8); hold on
plot(sol.x,sol.y(15,:),'k','linewidth',4);
xlim([0,time(end)])

% Pain Perception
figure(9); hold on
plot(sol.x,sol.y(9,:),'k','linewidth',4)
xlim([0,time(end)])

% IL10
figure(10); hold on
plot(sol.x,sol.y(2,:),'k','linewidth',4)
xlim([0,time(end)])

% Macrophages
figure(11); hold on
plot(sol.x,sol.y(5,:),'k','linewidth',4) % Activated Macrophages
plot(sol.x,sol.y(6,:),'k','linewidth',4) % Resting Macrophages
xlim([0,time(end)])

% LPS
figure(12); hold on
plot(sol.x,sol.y(7,:),'k','linewidth',4)
xlim([0,time(end)])
