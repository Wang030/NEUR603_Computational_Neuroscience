function C = Cwei_onnela_undirected(W)

%Onnela's weighted clustering coefficient for undirected graphs
%
% Mika Rubinov, 2007
% =========================================================================

K=sum(W~=0,2);            	
cyc3=diag((W.^(1/3))^3);           
K(cyc3==0)=inf;             %if no 3-cycles exist, make C=0 (via K=inf)
C=cyc3./(K.*(K-1));         %clustering coefficient
