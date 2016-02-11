% Set parameters of model
%
% p is a structure that contains all the parmeters for the simulation.
clear;
disp('---------- starting sim');

p.A = 4 * pi * 10; % surface area of neuron (um^2)

% set time steps and how long to run simulation
p.tStop = 350;  % mSec
p.dt = .05;     % msec

% injected current parameters
p.IinStart = 20;  % msec 
p.IinStop = 270;  % msec
p.Iin_nA = 0.0002;    % nA

% passive parameters
p.Em = -65;   % mV
p.rm = 25000; % ohms cm^2
p.cm = 1;     % uF / cm^2

% Kdr parameters
p.EK = -90;     % mV
p.gKdrBar = 4; %4;  % mS / cm^2

% Na parameters
p.ENa = 50;     % mV
p.gNaBar = 80; %80;  % mS / cm^2

p.Vrest = -65; % resting membrane potential (mV)

% run model using parameters in structure p
[t, v, n, m, h] = runSingleCompartmentSimulation(p);

% make our plots
figure(1);
hold on;
clf;

subplot(4,1,1);
plot(t, Iin(t, p));
set(gca,'Box', 'off');
ylabel('Iin (nA)');
axis tight;

subplot(4,1,2);
hold on;
% we need to regenerate our currents
[iKdr, nInf, taun] = Kdr(v, n, p);
[iNa, mInf, taum, hInf, tauh] = Na(v, m, h, p);
im = im(v,p);
% now plot the currents
plot(t,iKdr, 'k');
plot(t,iNa, 'r');
plot(t,im);
set(gca,'Box', 'off');
ylabel('(mA/cm^2)');
legend('iKdr', 'iNa', 'Im');
axis tight;

subplot(4,1,3);
hold on;
plot(t,n.^4);
plot(t,m.^3,'r');
plot(t,h,'k');
ylim([0 1]);
set(gca,'Box', 'off');
ylabel('Gating variables');
legend('n^4', 'm^3', 'h');
axis tight;

subplot(4,1,4);
plot(t,v);
set(gca,'Box', 'off');
xlabel('Time (ms)');
ylabel('Vm (mv)');
axis tight;





