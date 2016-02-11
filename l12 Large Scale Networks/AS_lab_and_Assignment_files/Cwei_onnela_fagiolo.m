function C = Cwei_onnela_fagiolo(W)

%Onnela's weighted clustering coefficient for directed graphs
%from Fagiolo 2006, arXiv:physics/0612169v2
%
% Mika Rubinov, 2007
% =========================================================================

A=W~=0;                     %adjacency matrix
S=W.^(1/3)+(W.').^(1/3);	%symmetrized weights matrix ^1/3
K=sum(A+A.',2);            	%total degree (in + out)
cyc3=diag(S^3)/2;           %number of 3-cycles (ie. directed triangles)
K(cyc3==0)=inf;             %if no 3-cycles exist, make C=0 (via K=inf)
CYC3=K.*(K-1)-2*diag(A^2);	%number of all possible 3-cycles
C=cyc3./CYC3;               %clustering coefficient

%See comments for Cbin_fagiolo
%The weighted modification is as follows:
%- The numerator: adjacency matrix is replaced with weights matrix ^ 1/3
%- The denominator: no changes from the binary version

%The above reduces to symmetric and/or binary versions of the
%   clustering coefficient for respective graphs.