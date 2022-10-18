function TreatAntipyretLPSadsorp(pars,Init,time)
% Antipyretics and LPS Adsorption

global SustEndotox
global intLPSadsop
global intAntipyret
global intVasopres

%%%Initialize interventions to false
SustEndotox     = true;
intLPSadsop     = true;
intAntipyret    = true;
intVasopres     = false;

parsAntipyretLPSadsorp = pars;
InitAntipyretLPSadsorp = Init;

%%% Run simulation
[sol] = modelDriver(parsAntipyretLPSadsorp,time,InitAntipyretLPSadsorp);

%%% Results for t>=4 hours, since start of intervention is t=4 hours
IND = find(sol.x >= 4);
sol.x = sol.x(IND); 
sol.y = sol.y(:,IND);

%%% Computations to obtain BP
Cla  = parsAntipyretLPSadsorp(70);    
Vla  = sol.y(10,:);  
pla  = Vla/Cla;      

%%% Plot model simulations

% TNF
figure(1); hold on
plot(sol.x,sol.y(1,:),'Color', [0.4940 0.1840 0.5560],'linewidth',4)
% xlim([0,time(end)])

% IL6
figure(2); hold on
plot(sol.x,sol.y(4,:),'Color', [0.4940 0.1840 0.5560],'linewidth',4)
% xlim([0,time(end)])

% IL8
figure(3); hold on
plot(sol.x,sol.y(3,:),'Color', [0.4940 0.1840 0.5560],'linewidth',4)
% xlim([0,time(end)])

% Temperature
figure(4); hold on
plot(sol.x,sol.y(8,:),'Color', [0.4940 0.1840 0.5560],'linewidth',4)
xlim([0,time(end)])

% Blood Pressure
figure(5); hold on
plot(sol.x,pla,'Color', [0.4940 0.1840 0.5560],'linewidth',4)
xlim([0,time(end)])

% Heart Rate
figure(6); hold on; 
plot(sol.x,sol.y(14,:),'Color', [0.4940 0.1840 0.5560],'linewidth',4)
xlim([0,time(end)])

% Vascular Resistance
figure(7); hold on; 
plot(sol.x,sol.y(16,:),'Color', [0.4940 0.1840 0.5560],'linewidth',4)
xlim([0,time(end)])

% Nitric Oxide
figure(8); hold on
plot(sol.x,sol.y(15,:),'Color', [0.4940 0.1840 0.5560],'linewidth',4)
xlim([0,time(end)])

% Pain Perception
figure(9); hold on
plot(sol.x,sol.y(9,:),'Color', [0.4940 0.1840 0.5560],'linewidth',4)
xlim([0,time(end)])

% IL10
figure(10); hold on
plot(sol.x,sol.y(2,:),'Color', [0.4940 0.1840 0.5560],'linewidth',4)
xlim([0,time(end)])

% Macrophages
figure(11); hold on
plot(sol.x,sol.y(5,:),'Color',[0.4940 0.1840 0.5560],'linewidth',4)  % Activated Macrophages
plot(sol.x,sol.y(6,:),'Color',[0.4940 0.1840 0.5560],'linewidth',4)  % Resting Macrophages
xlim([0,time(end)])

% LPS
figure(12); hold on
plot(sol.x,sol.y(7,:),'Color', [0.4940 0.1840 0.5560],'linewidth',4)
xlim([0,time(end)])