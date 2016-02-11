% Three-dimensional filtering operation for simulating a reverse correlation
% experiment.  The three-dimensional input a is filtered by the simulated
% neuron and the response is returned as a one-dimensional vector r.
% ccp 1/21/08

function r=threed(a)
[x,y,z]=size(a);
if (x~=y)
    error('Use square input images.');
    return;
end;
SIZE = x;
SF = 0.15;
SIG = 7;
OR = 90*pi/180;
AR = 3;
PH = 0;

k=25;  %Temporal scale factor 
slow_t=temp_imp_resp(5,k,0:.02:1);
fast_t=temp_imp_resp(3,k,0:.02:1);

b=slow_t + fast_t; % linear temporal filter

xdata = meshgrid(1:SIZE,1:SIZE);
temp1=(xdata-SIZE/2).*cos(OR)+(xdata'-SIZE/2).*sin(OR);
temp2=(-xdata+SIZE/2).*sin(OR)+(xdata'-SIZE/2).*cos(OR);

f1 = exp(-(temp1.*temp1+AR*AR*temp2.*temp2) / (2*SIG^2));
f2=  cos(2*pi*SF*temp2+PH);

rf_image = f1.*f2;
rf_image = rf_image - mean(mean(rf_image));
%r=rf_image;
%rf_image=rf_image.^2;
for i=1:z
    dp(i)=sum(sum(reshape(a(:,:,i),x,x).*rf_image));
end;

c=conv(b,dp); % convolve filter with stimulus
c=c./max(c); % normalize
c(find(c<0))=0;
%d=100./(1.0 + exp(10*(0.5-c))); % static nonlinearity

for j=1:length(c) % for spiking output
    if (c(j)>.4)
        r(j)=1;
    else
        r(j)=0;
    end;
end;

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