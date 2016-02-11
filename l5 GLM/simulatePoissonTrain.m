function y = simulatePoissonTrain(x,backfilter)
    y = zeros(size(x));
    for ii = 1:length(x)
        y(ii) = poissrnd(exp(x(ii)));
        if y(ii) > 0
            maxl = min(length(x) - ii,length(backfilter));
            x( (ii+(1:maxl))) = x( (ii+(1:maxl))) + backfilter(1:maxl);
        end
    end
end