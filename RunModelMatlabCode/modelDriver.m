function [sol] = modelDriver(pars,Init,time)

global ODE_TOL

options = odeset('RelTol',ODE_TOL,'AbsTol',ODE_TOL); 
sol = dde23(@model,0.4,Init,[time(1) time(end)],options,pars); 

