function C = Cbin_undirected(G,efficiency)

%clustering coefficient (local efficiency) for undirected binary graph
%
% Mika Rubinov, 2007
% =========================================================================

n=length(G);
C=zeros(n,1);

for u=1:n
    V=find(G(u,:));
    k=length(V);
    if k<2; continue, end               %...must be at least 2, or C=0;
    S=G([V],[V]);
    
    if nargin==2;
        C(u)=Lbin(S,efficiency);        %output local efficiency
    else
        C(u)=sum(S(:))/(k^2-k);
    end
end