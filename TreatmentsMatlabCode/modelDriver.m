function [sol] = modelDriver(pars,time,Init) 

global ODE_TOL ppars

ppars = pars;

options = odeset('RelTol',ODE_TOL,'AbsTol',ODE_TOL);
sol = dde23(@model,0.4,Init,[time(1) time(end)],options); 



