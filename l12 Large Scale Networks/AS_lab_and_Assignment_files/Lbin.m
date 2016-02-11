function D = Lbin(G,efficiency)

%Characteristic path length (or global efficiency) for binary matrices
%
% Mika Rubinov, 2007
% =========================================================================

D=eye(length(G));
n=1;
nPATH=G;                        %n-path matrix
L=(nPATH~=0);                   %shortest n-path matrix

while find(L,1);
    D=D+n.*L;
    n=n+1;
    nPATH=nPATH*G;
    L=(nPATH~=0).*(D==0);
end

D(D==0)=inf;                    %disconnected nodes have L=inf

if nargin==2, D = 1./D; end     %outputs efficiency

D=D-eye(length(G));