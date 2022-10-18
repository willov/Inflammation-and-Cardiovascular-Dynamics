function TransEndotoxFcn(pars,Init,time)

%Transient Endotoxemia

global SustEndotox
global intLPSadsop
global intAntipyret
global intVasopres

SustEndotox     = false;
intLPSadsop     = false;
intAntipyret    = false;
intVasopres     = false;

%%% Run simulation
[sol] = modelDriver(pars,time,Init);

%%% Computations to obtain BP
Cla  = pars(70);     
Vla  = sol.y(10,:);  
pla  = Vla/Cla;      

%%% Plot model simulations

% TNF
figure(1); clf;
plot(sol.x,sol.y(1,:),'Color',[0.8 0.8 0.8],'linewidth',4)
ylabel('TNF-\alpha (pg/mL)')
xlim([0,time(end)])
set(gca,'fontsize',24);

% IL6
figure(2); hold on
plot(sol.x,sol.y(4,:),'Color',[0.8 0.8 0.8],'linewidth',4)
ylabel('IL-6 (pg/mL)')
xlim([0,time(end)])
set(gca,'fontsize',24);

% IL8
figure(3); hold on
plot(sol.x,sol.y(3,:),'Color',[0.8 0.8 0.8],'linewidth',4)
ylabel('IL-8 (pg/mL)')
xlim([0,time(end)])
set(gca,'fontsize',24);

% Temperature
figure(4); hold on
plot(sol.x,sol.y(8,:),'Color',[0.8 0.8 0.8],'linewidth',4)
ylabel('Temp (^{\circ} C)')
xlim([0,time(end)])
set(gca,'fontsize',24);

% Blood Pressure
figure(5); hold on
plot(sol.x,pla,'Color',[0.8 0.8 0.8],'linewidth',4);
ylabel('BP (mmHg)')
xlim([0,time(end)])
set(gca,'fontsize',24);

% Heart Rate
figure(6); clf; 
plot(sol.x,sol.y(14,:),'Color',[0.8 0.8 0.8],'linewidth',4)
ylabel('HR (bpm)')
xlim([0,time(end)])
set(gca,'fontsize',24);

% Vascular Resistance
figure(7); clf; 
plot(sol.x,sol.y(16,:),'Color',[0.8 0.8 0.8],'linewidth',4)
ylabel('Rs (mmHg min/mL)')
set(gca,'fontsize',24);

% Nitric Oxide
figure(8); clf;
plot(sol.x,sol.y(15,:),'Color',[0.8 0.8 0.8],'linewidth',4);
ylabel('NO (n.d.)');
xlim([0,time(end)])
set(gca,'fontsize',24);

% Pain Perception
figure(9); clf;
plot(sol.x,sol.y(9,:),'Color',[0.8 0.8 0.8],'linewidth',4);
ylabel('PT (kPa)')
xlim([0,time(end)])
set(gca,'fontsize',24)

% IL10
figure(10); clf;
plot(sol.x,sol.y(2,:),'Color',[0.8 0.8 0.8],'linewidth',4);
ylabel('IL-10 (pg/mL)')
xlim([0,time(end)])
set(gca,'fontsize',24)

% Macrophages
figure(11); hold on
plot(sol.x,sol.y(5,:),'Color',[0.8 0.8 0.8],'linewidth',4); % Activated Macrophages
plot(sol.x,sol.y(6,:),'Color',[0.8 0.8 0.8],'linewidth',4); % Passive Macrophages
ylabel({'M (noc)'});
% xlim([0,time(end)])
set(gca,'fontsize',24)

% LPS
figure(12); hold on
plot(sol.x,sol.y(7,:),'Color',[0.8 0.8 0.8],'linewidth',4)
ylabel({'E (ng/kg)'});
xlim([0,time(end)])
set(gca,'fontsize',24);