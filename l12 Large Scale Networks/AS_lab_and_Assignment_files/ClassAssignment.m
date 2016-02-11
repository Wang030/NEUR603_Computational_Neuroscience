% Step 1: 

% graphshortestpath
distant = zeros(71);
for i=1:71
    for j=1:71
        distant(i,j)=graphshortestpaths(CIJ,i,j);
    end
end