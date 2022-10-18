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

global time Init  
global SustEndotox
global intLPSadsop
global intAntipyret
global intVasopres

%%%Initialize interventions to false
SustEndotox     = false;
intLPSadsop     = false;
intAntipyret    = false;
intVasopres     = false;

%%%Import initial conditions and parameter array
[pars,Init] = load_pars_Init;

%%%Set simulation time
time = [0 13];

%%% Lines 22-32 Runs model and plot Transient Endotoxemia, Sustained
%%% Endotoxemia and single treatments
TransEndotoxFcn(pars,Init,time);     % Transient Endotoxemia - gray
TSustEndotoxFcn(pars,Init,time);     % Sustained Endotoxemia - black
TreatLPSadsorp(pars,Init,time);      % LPS Adsorption - blue'
TreatAntipyret(pars,Init,time);      % Antipyretics - red
TreatVasopres(pars,Init,time);       % Vasopressors - green

figure(12); hold on
legend('Transient Endotoxemia','Sustained Endotoxemia','LPS Adsorpotion',...
      'Antipyretics','Vasopressors')
   
%%% Lines 34-47 Runs model and plot Transient Endotoxemia, Sustained
%%% Endotoxemia and treatment combinations
% TransEndotoxFcn(pars,Init,time);         % Transient Endotoxemia - gray
% SustEndotoxFcn(pars,Init,time);          % Sustained Endotoxemia - black
% TreatAntipyretLPSadsorp(pars,Init,time); % LPS Adsorption & Antipyretics - purple
% TreatVasopresLPSadsorp(pars,Init,time);  % LPS Adsorption & Vasopressors - cyan
% TreatAntipyretVasopres(pars,Init,time);  % Antipyretics & Vasopressors - mustard
% TreatComb(pars,Init,time);               % All three - navy blue
% 
% figure(12); hold on
% legend('Transient Endotoxemia','Sustained Endotoxemia','LPS Adsorpotion & Antipyretics',...
%        'LPS Adsorpotion & Vasopressors','Antipyretics & Vasopressors',...
%        'All Three Interventions')

Str = {'TNF','IL6','IL8','Temp','BP','HR','Rs','NO','PT','IL10','M','E'}; j = 1;
for i = 1:12
    figure(i); hold on
    set(gca,'fontsize',24)
    xlabel('Time (hr)')
    xticks([0:2:12])
    xlim([0 12])
    set(gcf, 'units','normalized','outerposition',[0 0 0.5 0.5]);
    j = j+1;
end