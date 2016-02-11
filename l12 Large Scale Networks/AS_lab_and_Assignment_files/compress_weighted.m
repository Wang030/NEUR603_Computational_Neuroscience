function [subgraphs, intensities, coherences] = compress_weighted(CIJ, subsets, m);


nsub = size(subsets,1);
h = find(ones(m)-eye(m));
subgraphs = zeros(nsub,1);
intensities = zeros(nsub,1);
coherences = zeros(nsub,1);

for i = 1:nsub;
    b = CIJ(subsets(i,:),subsets(i,:));    % extracts subgraph
    c = b(h)';                              % takes out diagonal, which is always all 0;                                  
    d = c > 0;
    intensities(i) = prod(c(d))^(1/sum(d));
    coherences(i) = intensities(i)/mean(c(d));
    subgraphs(i) = sum(d.*2.^[length(h)-1:-1:0]);   % turns back into a number, transforming from binary to decimal
end
