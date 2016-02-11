clear all

fs = 1000;
Ts = 1/fs;


% I. Define the Canal afferent paramters
g = 1; % gain
T1 = 5.7;% canals long time constant
T2 = 0.003;% canals short time constant
T = 0.015; % zero time constant


f = 0.5; 

L = 100;
t = [1/fs:1/fs:L]';

% input = 10*sin (2*pi*f*t);

sim ('afferent_step_response',[Ts L]);

figure, hold all, plot(t,input),plot(t,simout), title ('Canal Afferent Step Response')
legend ('input','output'),xlabel ('Time (sec)'), ylabel ('amplitude (deg/s)')
