function i = Iin(t, p)

    i = zeros(size(t));

    % determine input current
    for k = 1 : length(t)
        if t(k) >= p.IinStart && t(k) < p.IinStop
            i(k) = p.Iin_nA;
        else
            i(k) = 0;
        end
    end
end