function D=Lwei(G)

%Characteristic path length for weighted graph G (Dijkstra's algorithm)
%
% Mika Rubinov, 2007
% =========================================================================

n=length(G);
E=find(G); G(E)=1./G(E);        %invert weights: large -> short
D=zeros(n); D(~eye(n))=inf;     %distance matrix

for u=1:n
    S=true(1,n);                %distance permanence (true is temporary)
    G1=G;
    V=u;
    while 1
        S(V)=0;                 %distance u->V is now permanent
        G1(:,V)=0;              %no in-edges as already shortest
        for v=V
            W=find(G1(v,:));	%neighbours of shortest nodes
            for w=W;
                D(u,w)=min(D(u,w),D(u,v)+G1(v,w));
                %the smallest of old (if exist) and current path lengths
            end
        end

        minD=min(D(u,S));
        if isempty(minD)||isinf(minD), break, end;
        %isempty: all nodes reached; isinf: some nodes cannot be reached
        V=find(D(u,:)==minD);
    end
end