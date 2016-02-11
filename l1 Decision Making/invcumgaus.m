function y = invcumgaus(x,m,v)

y = v*sqrt(2) * erfinv(2*x-1) + m;