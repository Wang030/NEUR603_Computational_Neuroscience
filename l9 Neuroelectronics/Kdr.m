function [i, nInf, taun] = Kdr(v, n, p)

    b = .07;
	v0 = -50;
    
    for j = 1 : length(v)

        nInf(j) = 1 ./ (1 + exp(-b .* (v(j) - v0)));
        taun = 1;

        i(j) = p.gKdrBar * n(j)^4 * (v(j) - p.EK) * 1e-3;  % mA / cm^2
    end
end