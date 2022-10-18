function TreatComb(pars,Init,time)
% Combined treatment

global SustEndotox
global intLPSadsop
global intAntipyret
global intVasopres

SustEndotox     = true;
intLPSadsop     = true;
intAntipyret    = true;
intVasopres     = true;

parsComb = pars;
InitComb = Init;

%%% Run simulation
[sol] = modelDriver(parsComb,time,InitComb);

%%% Results for t>=4 hours, since start of intervention is t=4 hours
IND   = find(sol.x >= 4);
sol.x = sol.x(IND); 
sol.y = sol.y(:,IND);

%%% Computations to obtain BP
Cla  = parsComb(70);    
Vla  = sol.y(10,:);  
pla  = Vla/Cla;      

%%% Plot results from model simulations

% TNF
figure(1); hold on
plot(sol.x,sol.y(1,:),'b--','linewidth',4)
xlim([0,time(end)])

% IL6
figure(2); hold on
plot(sol.x,sol.y(4,:),'b--','linewidth',4)
xlim([0,time(end)])

% IL8
figure(3); hold on
plot(sol.x,sol.y(3,:),'b--','linewidth',4)
xlim([0,time(end)])

% Temperature
figure(4); hold on
plot(sol.x,sol.y(8,:),'b--','linewidth',4)
xlim([0,time(end)])

% Blood Pressure
figure(5); hold on
plot(sol.x,pla,'b','linewidth',4)
xlim([0,time(end)])

% Heart Rate 
figure(6); hold on
plot(sol.x,sol.y(14,:),'b','linewidth',4)
xlim([0,time(end)])

% Vascular Resistance
figure(7); hold on
plot(sol.x,sol.y(16,:),'b','linewidth',44)
xlim([0,time(end)])

% Nitric Oxide
figure(8); hold on
plot(sol.x,sol.y(15,:),'b--','linewidth',4)
xlim([0,time(end)])

% Pain Perception
figure(9); hold on
plot(sol.x,sol.y(9,:),'b--','linewidth',4)
xlim([0,time(end)])

% IL10
figure(10); hold on
plot(sol.x,sol.y(2,:),'b--','linewidth',4)
xlim([0,time(end)])

% Macrophages
figure(11); hold on
plot(sol.x,sol.y(5,:),'b--','linewidth',4)  % Activated Macrophages
plot(sol.x,sol.y(6,:),'b--','linewidth',4)  % Resting Macrophages
xlim([0,time(end)])

% LPS
figure(12); hold on
plot(sol.x,sol.y(7,:),'b--','linewidth',4)
xlim([0,time(end)])
