% One dimensional filtering operation for simulating a reverse correlation
% experiment.  The input a is filtered by the simulated neuron and the
% response is returned in r.
% Christopher Pack, 11/07

function r=oned(a)

k=25;  %Temporal scale factor 
slow_t=temp_imp_resp(5,k,0:.02:1);
fast_t=temp_imp_resp(3,k,0:.02:1);

b=slow_t + fast_t; % linear filter

c=conv(b,a); % convolve filter with stimulus
c=c./max(c); % normalize

d=100./(1.0 + exp(10*(0.5-c))); % static nonlinearity
r=d; % for continuous output

%for j=1:length(d) % for spiking output
%    if (rand(1)<d(j))
%        r(j)=1;
%    else
%        r(j)=0;
%    end;
%end;

return;

function time_response=temp_imp_resp(n,k,t)
%time_response=temp_imp_resp(n,k,t)
%
%Produces a temporal impulse response function using the from from
%figure 1 in Adelson & Bergen (1985)
%
%It's pretty much a difference of Poisson functions with different
%time constants.

time_response=(k*t).^n .* exp(-k*t).*(1/factorial(n)-(k*t).^2/factorial(n+2));