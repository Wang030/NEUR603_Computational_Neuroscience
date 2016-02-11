function b = three_var(v,input)
x = v(1);
y = v(2);
b = max(100)./(1+exp(x*(y-input)));
return;