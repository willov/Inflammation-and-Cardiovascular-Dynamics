%%% ----------------------------------------------------------------------------
% Copyright (c) 2021 by researchers in the NCSU cardiovascular dynamics
% group. Contact Information: msolufse (at) ncsu (dot) edu
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% (1) The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software,
%
% (2) All users utilizing this code or subsequent versions must cite
% "A physiological model of the inflammatory-thermal-pain-cardiovascular
% interactions during an endotoxin challenge" by A Dobreva, 
% R Brady-Nicholls, K. Larripa, C. Puelz, J. Mehlsen, M.S. Olufsen,
% Accepted for publication in Journal of Physiology. A preprint is available
% at https://arxiv.org/abs/1908.07611.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.
%%% ----------------------------------------------------------------------------
% clear all;
%close all;

global Init Tm BPo 

load DataJanum.mat   %File with data

D = struct();

%%%Blood pressure(BP),and heart rate(HR), cytokine, temperature(Temp) and pain data
BPtime     = BPt;
BP         = BPm;
BPsd       = BPsd;
data.BP    = BP;

D.BP = struct();
D.BP.Time = BPt;
D.BP.Mean = BPm; 
D.BP.SD = BPsd;
D.BP.SEM = BPsd./sqrt(10);

HRtime 	   = HRt;
HR 		   = HRm;
HRsd 	   = HRsd;
data.HR    = HR;

D.HR = struct();
D.HR.Time = HRt;
D.HR.Mean = HRm; 
D.HR.SD = HRsd;
D.HR.SEM = HRsd./sqrt(10);


IMMUNEtime = TNFt;
TNF        = TNFm;
TNFsd 	   = TNFsd;
data.TNF   = TNF;

D.TNF = struct();
D.TNF.Time = TNFt;
D.TNF.Mean = TNFm; 
D.TNF.SD = TNFsd;
D.TNF.SEM = TNFsd./sqrt(10);


IL6 	   = IL6m;
IL6eb 	   = IL6sd;
data.IL6   = IL6;
D.IL6 = struct();
D.IL6.Time = IL6t;
D.IL6.Mean = IL6m; 
D.IL6.SD = IL6sd;
D.IL6.SEM = IL6sd./sqrt(10);


IL8 	   = IL8m;
IL8as 	   = IL8sd;
data.IL8   = IL8;

D.IL8 = struct();
D.IL8.Time = IL8t;
D.IL8.Mean = IL8m; 
D.IL8.SD = IL8sd;
D.IL8.SEM = IL8sd./sqrt(10);


IL10 	   = IL10m;
IL10eb 	   = IL10sd;
data.IL10  = IL10;

D.IL10 = struct();
D.IL10.Time = IMMUNEtime;
D.IL10.Mean = IL10m; 
D.IL10.SD = IL10sd;
D.IL10.SEM = IL10sd./sqrt(10);


TEMPtime   = TEMPt;
TEMP 	   = TEMPm;
TEMPsd 	   = TEMPsd;
data.temp  = TEMP;

D.TEMP = struct();
D.TEMP.Time = TEMPt;
D.TEMP.Mean = TEMPm; 
D.TEMP.SD = TEMPsd;
D.TEMP.SEM = TEMPsd./sqrt(10);


PAINtime   = PAINt;
PAIN 	   = PAINm;
PAINeb 	   = PAINsd;
data.pain  = PAIN;

D.HR = struct();
D.HR.Time = HRt;
D.HR.Mean = HRm; 
D.HR.SD = HRsd;
D.HR.SEM = HRsd./sqrt(10);


%%%Age, weight and height data
data.age 	= 24.68;
data.weight = 76.08;
data.height = 182.575;
data.HM = 207 - 0.7*(data.age);

D.meta = struct();
D.meta.age = data.age;
D.meta.weight = data.weight;
D.meta.height = data.height;


%%%Set baseline BP
BPo=BP(1,1);

%%%Set baseline Temp 
Tm=data.temp(1); 

%%%Import initial conditions and parameter array
[pars,Init] = load_pars_Init_Janum(data);

%%%Run simulation
global lag
lag = [];
[sol] = modelDriver(pars,Init,[0 8]);

modelName = 'fever';
IQMmakeMEXmodel(IQMmodel([modelName '.txt']))
newmodel = str2func(modelName);
t = sol.x;
params = [pars; pars(87)];
sim = newmodel(t, Init, params);




figure(9992)
subplot(2,2,1)
plot(lag(:,1), lag(:,2))
ylabel('lag1')
xlabel('Time')
subplot(2,2,2)
plot(lag(:,1), lag(:,3))
ylabel('lag2')
xlabel('Time')
subplot(2,2,3)
plot(lag(:,1), lag(:,4))
ylabel('lag-effect')
xlabel('Time')
sgtitle('Lags, Janum')

nstates = length(sim.states);
[m,n] = CloseToSquare(nstates);

figure(9992); clf;
for i = 1:nstates
    subplot(m,n,i)
    plot(sim.time, sim.statevalues(:,i))
    hold on 
    plot(sol.x, sol.y(i,:),'--')
    legend({'IQM','Org'})
    title(sim.states{i})
end
sgtitle('All states, Janum')

%%%Computations to obtain BP
Vla  = sol.y(10,:);
Cla  = pars(70); 
pla  = Vla/Cla;

%%%Plot simuation results and data
figure(2); %clf;
set(gcf, 'units','normalized','outerposition',[0 0 0.5 0.5])

subplot(3,3,1)
h1=plot(sol.x,pla,'k','linewidth',4);
hold on
plot(sim.time, sim.variablevalues(:,4),'b--', 'linewidth',4)
errorbar(BPtime,BP,BPsd,'bo', 'MarkerSize',12,'MarkerFaceColor','b','linewidth',2);
ylabel('BP (mmHg)');
xlabel('Time (hr)');
set(gca,'fontsize',24)
xlim([0,8])
% set(gcf, 'units','normalized','outerposition',[0 0 0.5 0.5])
grid on;
legend({'Org', 'IQM', 'Data'})


%figure(2); clf;
subplot(3,3,2)
h2=plot(sol.x,sol.y(14,:),'k','linewidth',4);
hold on
plot(sim.time, sim.statevalues(:,14),'b--', 'linewidth',4)
errorbar(HRtime,HR,HRsd,'bo', 'MarkerSize',12,'MarkerFaceColor','b','linewidth',2);
ylabel('HR (bpm)');
xlabel('Time (hr)');
set(gca,'fontsize',24)
xlim([0,8])
% set(gcf, 'units','normalized','outerposition',[0 0 0.5 0.5])
grid on;
legend({'Org', 'IQM', 'Data'})

% figure(3); clf;
subplot(3,3,3)
h3=plot(sol.x,sol.y(1,:),'k','linewidth',4);
hold on
plot(sim.time, sim.statevalues(:,1),'b--', 'linewidth',4)
errorbar(IMMUNEtime,TNF,TNFsd,'bo', 'MarkerSize',12,'MarkerFaceColor','b','linewidth',2);
set(gca,'fontsize',24);
ylabel({'TNF-\alpha (pg/mL)'});
xlabel('Time (hr)');
ylim([0 700]);
xlim([0,8])
% set(gcf, 'units','normalized','outerposition',[0 0 0.5 0.5])
grid on;
legend({'Org', 'IQM', 'Data'})


% figure(4); clf;
subplot(3,3,4)
h4=plot(sol.x,sol.y(2,:),'k','linewidth',4);
hold on
plot(sim.time, sim.statevalues(:,2),'b--', 'linewidth',4)
errorbar(IMMUNEtime,IL10,IL10sd,'bo', 'MarkerSize',12,'MarkerFaceColor','b','linewidth',2);
set(gca,'fontsize',24);
ylabel({'IL-10 (pg/mL)'});
xlabel('Time (hr)');
ylim([0 80]);
xlim([0,8])
% set(gcf, 'units','normalized','outerposition',[0 0 0.5 0.5])
grid on;

% figure(5); clf;
subplot(3,3,5)
h5=plot(sol.x,sol.y(3,:),'k','linewidth',4);
hold on
plot(sim.time, sim.statevalues(:,3),'b--', 'linewidth',4)
errorbar(IMMUNEtime,IL8,IL8sd,'bo', 'MarkerSize',12,'MarkerFaceColor','b','linewidth',2);
set(gca,'fontsize',24);
ylabel({'IL-8 (pg/mL)'});
xlabel('Time (hr)');
ylim([-10 900]);
xlim([0,8])
% set(gcf, 'units','normalized','outerposition',[0 0 0.5 0.5])
grid on;
legend({'Org', 'IQM', 'Data'})


%figure(6); clf;
subplot(3,3,6)
h6=plot(sol.x,sol.y(4,:),'k','linewidth',4);
hold on
plot(sim.time, sim.statevalues(:,4),'b--', 'linewidth',4)
errorbar(IMMUNEtime,IL6,IL6sd,'bo', 'MarkerSize',12,'MarkerFaceColor','b','linewidth',2);
set(gca,'fontsize',24);
ylabel({'IL-6 (pg/mL)'});
xlabel('Time (hr)');
ylim([-10 1400]);
xlim([0,8])
% set(gcf, 'units','normalized','outerposition',[0 0 0.5 0.5])
grid on;
legend({'Org', 'IQM', 'Data'})


% figure(7); clf;
subplot(3,3,7)
h7=plot(sol.x,sol.y(8,:),'k','linewidth',4);
hold on
plot(sim.time, sim.statevalues(:,8),'b--', 'linewidth',4)
errorbar(TEMPtime,TEMP,TEMPsd,'bo', 'MarkerSize',12,'MarkerFaceColor','b','linewidth',2);
hold on
ylabel('Temp (^{\circ} C)')
xlabel('Time (hr)');
set(gca,'fontsize',24);
% set(gcf, 'units','normalized','outerposition',[0 0 0.5 0.5])
grid on;
legend({'Org', 'IQM', 'Data'})


%figure(8); clf;
subplot(3,3,8)
h8=plot(sol.x,sol.y(9,:),'k','linewidth',4);
hold on
plot(sim.time, sim.statevalues(:,9),'b--', 'linewidth',4)
errorbar(PAINtime,PAIN,PAINsd,'bo', 'MarkerSize',12,'MarkerFaceColor','b','linewidth',2);
ylabel('PPT (kPa)')
xlabel('Time (hr)');
set(gca,'fontsize',24)
xlim([0,8])
% set(gcf, 'units','normalized','outerposition',[0 0 0.5 0.5])
grid on;
legend({'Org', 'IQM', 'Data'})



