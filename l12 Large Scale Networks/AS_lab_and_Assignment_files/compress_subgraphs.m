function [subgraphs] = compress_subgraphs(CIJ,subsets,M)

nsub = size(subsets,1);
h = find(ones(M)-eye(M));
pow2 = 2.^(length(h)-1:-1:0);

subgraphs = zeros(1,nsub);

for i=1:nsub
    % extract subgraph and transform to binary and decimal
    b = CIJ(subsets(i,:),subsets(i,:));                            
    subgraphs(i) = sum(b(h)'.*pow2);
end
