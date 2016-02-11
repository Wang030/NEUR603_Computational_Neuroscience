function dy = singleCompartment(t, y, p)

    v = y(1);
    n = y(2);
    m = y(3);
    h = y(4);

    % convert area to cm^2
    A = p.A * 1e-8;    % convert to cm^2
    
    Iin_mA = Iin(t, p) * 1e-6; % convert to mA
    
    % all currents are mA / cm^2
    
    % update Im
    Ipass = im(v, p);
   
    % update Ikdr
    [iKdr, nInf, taun] = Kdr(v, n, p);
    
    % update Ikdr
    [iNa, mInf, taum, hInf, tauh] = Na(v, m, h, p);
   
    dhdt = (hInf - h) / tauh;
    dmdt = (mInf - m) / taum;
    dndt = (nInf - n) / taun;
    dvdt = (Iin_mA / A - Ipass - iKdr - iNa) / (p.cm * 1e-3); % dvdt is A / F
    
    dy = zeros(4,1);
    dy(1) = dvdt;
    dy(2) = dndt;
    dy(3) = dmdt;
    dy(4) = dhdt;
end