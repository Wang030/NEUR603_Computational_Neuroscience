function [f F]=motif3count(A)
%[f F]=motif3count(A)
%Input: binary directed graph A
%Output: binary motif count f; binary motif count per vertex F
%
%Motif matrices for a given MOTIF_ID are obtained via:
% load motif34lib M3 ID3
% for i=find(ID3==MOTIF_ID).'
%     reshape([0 M3(i,1:3) 0 M3(i,4:6) 0],3,3)
% end
%
%Motif ID for a given MOTIF_MATRIX is obtained via
% find(motif3count([MOTIF_MATRIX]))
%
%Mika Rubinov, July 2007

n=length(A);                                %number of vertices in A
F=zeros(13,n);                              %motif count of each vertex
f=zeros(13,1);                              %motif count for whole graph
As=A|A.';                                   %symmetrized adjacency matrix
load motif34lib M3n ID3                  	%load motif data

for u=1:n-2                               	%loop u 1:n-2
    V1=[false(1,u) As(u,u+1:n)];         	%v1: neibs of u (>u)
    for v1=find(V1)
        V2=[false(1,u) As(v1,u+1:n)];       %v2: all neibs of v1 (>u)
        V2(V1)=0;                           %not already in V1
        V2=([false(1,v1) As(u,v1+1:n)])|V2; %and all neibs of u (>v1)
        for v2=find(V2)

            s=uint32(sum(10.^(5:-1:0).*[A(v1,u) A(v2,u) A(u,v1)...
                A(v2,v1) A(u,v2) A(v1,v2)]));
            ind=ID3(s==M3n);
            if nargout==2; F(ind,[u v1 v2])=F(ind,[u v1 v2])+1; end
            f(ind)=f(ind)+1;
        end
    end
end