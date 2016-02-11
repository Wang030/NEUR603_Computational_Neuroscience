function [i, mInf, taum, hInf, tauh] = Na(v, m, h, p)
%
% Function should return Na current and the steady-state gating variables m
% and h.  Taus for m and h are given.
%
%
    v0h=-55;
    v0m=-42;
    
    tauh = .6;
    taum = .15;
    
    % function currently sets everything to zero.
    i = zeros(size(v));
    mInf = zeros(size(v));
    hInf = zeros(size(v));
    
    for j = 1 : length(v)
        hInf(j) = 1 -1./ (1 + exp(-.2 .* (v(j) - v0h)));
        mInf(j) = 1 ./ (1 + exp(- .15 * (v(j) - v0m)));
        i(j) = p.gNaBar * m(j)^3 * h(j)*(v(j) - p.ENa) * 1e-3;  % mA / cm^2
    end
end
