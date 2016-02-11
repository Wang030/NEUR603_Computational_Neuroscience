function [t, v, n, m, h] = runSingleCompartmentSimulation(p)
% Set up initial conditions and run simulation

    % set inital conditions 
    [iKdr, nInf, taun] = Kdr(p.Vrest, 0, p); % get nInf for initial conditions
    [iNa, mInf, taum, hInf, tauh] = Na(p.Vrest, 0, 0, p); % get mInf and hInf for initial conditions


    % at Vrest we want the net current to be zero.  Therefore, we use iKdr
    % and iNa to set passive reversal potential
    [iNa, mInf, taum, hInf, tauh] = Na(p.Vrest, mInf, hInf, p); % use nInf to get iNa at Vrest
    [iKdr, nInf, taun] = Kdr(p.Vrest, nInf, p); % use mInf and hInf to get iKdr at Vrest
    
    p.Em = p.rm * (iKdr + iNa) + p.Vrest;
    
    p % display model parameters


    % run model using a Matlab ODE solver.  Returns time and a four column
    % matrix y where each column contains one of our time dependent
    % variables v, n, m, and h. We pass this function the name of our model
    % (single compartment), the time points for running the model (tSpan)
    % and the initial conditions (Vrest, nInf, mInf and hInf). 
    tSpan = 0 : p.dt : p.tStop;
    [t, y] = ode15s(@(t, y)singleCompartment(t, y, p), tSpan, [p.Vrest nInf mInf hInf]);

    % extract our time dependent variables from y
    v = y(:, 1); % membrane potential
    n = y(:, 2);
    m = y(:, 3);
    h = y(:, 4);

end