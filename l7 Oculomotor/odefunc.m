function dy = odefunc(t,y,F,p)

F = interp1(p.t,F,t);
dy = (F' - p.K * y)./p.R;

end