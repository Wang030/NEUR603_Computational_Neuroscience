function C = Cbin_fagiolo(A)

%clustering coefficient for directed binary graphs
%from Fagiolo 2006, arXiv:physics/0612169v2
%
% Mika Rubinov, 2007
% =========================================================================

S=A+A.';                    %symmetrized input graph
K=sum(S,2);                 %total degree (in + out)
cyc3=diag(S^3)/2;           %number of 3-cycles (ie. directed triangles)
K(cyc3==0)=inf;             %if no 3-cycles exist, make C=0 (via K=inf)
CYC3=K.*(K-1)-2*diag(A^2);	%number of all possible 3-cycles
C=cyc3./CYC3;               %clustering coefficient

%In directed graphs, 3 nodes generate up to 8 triangles (2*2*2 edges)
%The number of existing triangles is the main diagonal of S^3/2
%The number of all (in or out) neighbour pairs is K(K-1)/2
%Each neighbour pair may generate two triangles
%"False pairs" are i<->j edge pairs (these do not generate triangles)
%The number of false pairs is the main diagonal of A^2
%Thus the maximum possible number of triangles = 
%  = (2 edges)*([ALL PAIRS] - [FALSE PAIRS]) =
%  = 2 * (K(K-1)/2 - diag(A^2)) = K(K-1) - 2(diag(A^2))