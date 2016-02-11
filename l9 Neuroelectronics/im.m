function i = im(v, p)

    % determine im
    gm = 1 / p.rm * 1e3;  % mS / cm^2  
    i = gm * (v - p.Em) * 1e-3; % mA / cm^2
    
end