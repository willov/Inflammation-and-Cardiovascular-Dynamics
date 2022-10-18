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
clear all;
close all;

global Init Tm BPo 

load DataJanum.mat   %File with data

%%%Blood pressure(BP),and heart rate(HR), cytokine, temperature(Temp) and pain data
BPtime     = BPt;
BP         = BPm;
BPsd       = BPsd;
data.BP    = BP;

HRtime 	   = HRt;
HR 		   = HRm;
HRsd 	   = HRsd;
data.HR    = HR;

IMMUNEtime = TNFt;
TNF        = TNFm;
TNFsd 	   = TNFsd;
data.TNF   = TNF;

IL6 	   = IL6m;
IL6eb 	   = IL6sd;
data.IL6   = IL6;

IL8 	   = IL8m;
IL8as 	   = IL8sd;
data.IL8   = IL8;

IL10 	   = IL10m;
IL10eb 	   = IL10sd;
data.IL10  = IL10;

TEMPtime   = TEMPt;
TEMP 	   = TEMPm;
TEMPsd 	   = TEMPsd;
data.temp  = TEMP;

PAINtime   = PAINt;
PAIN 	   = PAINm;
PAINeb 	   = PAINsd;
data.pain  = PAIN;

%%%Age, weight and height data
data.age 	= 24.68;
data.weight = 76.08;
data.height = 182.575;

data.HM = 207 - 0.7*(data.age);

%%%Set baseline BP
BPo=BP(1,1);

%%%Set baseline Temp 
Tm=data.temp(1); 

%%%Import initial conditions and parameter array
[pars,Init] = load_pars_Init_Janum(data);

%%%Run simulation
[sol] = modelDriver(pars,Init,[0 8]);

%%%Computations to obtain BP
Vla  = sol.y(10,:);
Cla  = pars(70); 
pla = Vla/Cla;   

%%%Plot simuation results and data
figure(1); clf;
h1=plot(sol.x,pla,'k','linewidth',4);
hold on
errorbar(BPtime,BP,BPsd,'bo', 'MarkerSize',12,'MarkerFaceColor','b','linewidth',2);
ylabel('BP (mmHg)');
xlabel('Time (hr)');
set(gca,'fontsize',24)
xlim([0,8])
set(gcf, 'units','normalized','outerposition',[0 0 0.5 0.5])
grid on;

figure(2); clf;
h2=plot(sol.x,sol.y(14,:),'k','linewidth',4);
hold on
errorbar(HRtime,HR,HRsd,'bo', 'MarkerSize',12,'MarkerFaceColor','b','linewidth',2);
ylabel('HR (bpm)');
xlabel('Time (hr)');
set(gca,'fontsize',24)
xlim([0,8])
set(gcf, 'units','normalized','outerposition',[0 0 0.5 0.5])
grid on;

figure(3); clf;
h3=plot(sol.x,sol.y(1,:),'k','linewidth',4);
hold on
errorbar(IMMUNEtime,TNF,TNFsd,'bo', 'MarkerSize',12,'MarkerFaceColor','b','linewidth',2);
set(gca,'fontsize',24);
ylabel({'TNF-\alpha (pg/mL)'});
xlabel('Time (hr)');
ylim([0 700]);
xlim([0,8])
set(gcf, 'units','normalized','outerposition',[0 0 0.5 0.5])
grid on;

figure(4); clf;
h4=plot(sol.x,sol.y(2,:),'k','linewidth',4);
hold on
errorbar(IMMUNEtime,IL10,IL10sd,'bo', 'MarkerSize',12,'MarkerFaceColor','b','linewidth',2);
set(gca,'fontsize',24);
ylabel({'IL-10 (pg/mL)'});
xlabel('Time (hr)');
ylim([0 80]);
xlim([0,8])
set(gcf, 'units','normalized','outerposition',[0 0 0.5 0.5])
grid on;

figure(5); clf;
h5=plot(sol.x,sol.y(3,:),'k','linewidth',4);
hold on
errorbar(IMMUNEtime,IL8,IL8sd,'bo', 'MarkerSize',12,'MarkerFaceColor','b','linewidth',2);
set(gca,'fontsize',24);
ylabel({'IL-8 (pg/mL)'});
xlabel('Time (hr)');
ylim([-10 900]);
xlim([0,8])
set(gcf, 'units','normalized','outerposition',[0 0 0.5 0.5])
grid on;

figure(6); clf;
h6=plot(sol.x,sol.y(4,:),'k','linewidth',4);
hold on
errorbar(IMMUNEtime,IL6,IL6sd,'bo', 'MarkerSize',12,'MarkerFaceColor','b','linewidth',2);
set(gca,'fontsize',24);
ylabel({'IL-6 (pg/mL)'});
xlabel('Time (hr)');
ylim([-10 1400]);
xlim([0,8])
set(gcf, 'units','normalized','outerposition',[0 0 0.5 0.5])
grid on;

figure(7); clf;
h7=plot(sol.x,sol.y(8,:),'k','linewidth',4);
hold on
errorbar(TEMPtime,TEMP,TEMPsd,'bo', 'MarkerSize',12,'MarkerFaceColor','b','linewidth',2);
hold on
ylabel('Temp (^{\circ} C)')
xlabel('Time (hr)');
set(gca,'fontsize',24);
set(gcf, 'units','normalized','outerposition',[0 0 0.5 0.5])
grid on;

figure(8); clf;
h8=plot(sol.x,sol.y(9,:),'k','linewidth',4);
hold on
errorbar(PAINtime,PAIN,PAINsd,'bo', 'MarkerSize',12,'MarkerFaceColor','b','linewidth',2);
ylabel('PPT (kPa)')
xlabel('Time (hr)');
set(gca,'fontsize',24)
xlim([0,8])
set(gcf, 'units','normalized','outerposition',[0 0 0.5 0.5])
grid on;

