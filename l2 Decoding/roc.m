function cp = roc(x2, x1)
%
% cp = area under the roc curve, x2/x1 is a list, 10$ twice as fast
% cp = roc(x2, x1)
%
% ROC analysis of distributions x1 and x2.  Assumes we use rule that
% samples in x1 are on average greater than x2.

    x1 = sort(x1(:));
    x2 = sort(x2(:));
    
    % tricky part to find duplicates in each distribution
    [b1, n1] = unique(x1);
    [b2, n2] = unique(x2);
    u = [[-inf 0 0] ; union([b1 [n1(1) ; diff(n1)]/length(x1) zeros(size(b1))], ...
        [b2 zeros(size(b2)) [n2(1) ; diff(n2)]/length(x2)],'rows')];
    
    % find duplicates across both distributions
    [uu, i] = unique(u(:,1));
        
    u = cumsum(u(:,[2 3]), 1);
    u = u(i, :);
    
    % uu is list of unique points (ie union(x1 and x2)) and u is the corresponding cdf at x for
    % each distribution
    
    %[uu u]
   
    cp = trapz(u(:,1), u(:,2));  % integrate roc curve with trapezoid rule
    % trapz, numerical integration
end