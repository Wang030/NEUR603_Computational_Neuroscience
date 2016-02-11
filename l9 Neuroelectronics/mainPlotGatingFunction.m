%% Plot gating functions

% Kdr
p.EK = -90;
p.gKdrBar = 4;

% Na
p.ENa = 50;
p.gNaBar = 60;

% set voltage range
v = -100 : 20;

% compute nInf
[iKdr, nInf, taun] = Kdr(v, zeros(size(v)), p);

% compute mInf and hInf
[iNa, mInf, taum, hInf, tauh] = Na(v, zeros(size(v)), zeros(size(v)), p);

figure(1);
clf;
hold on;

plot(v, nInf.^4, 'LineWidth', 3);
plot(v, mInf.^3, 'r', 'LineWidth', 3);
plot(v, hInf, 'k' , 'LineWidth', 3);
legend('nInf^4', 'mInf^3', 'hInf');
xlabel('v (mv)');