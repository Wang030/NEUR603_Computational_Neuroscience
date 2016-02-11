function make_motif34lib
%Generates motif library for use in binary and weighted motif functions.

[M3 M3n ID3 N3]=motif3generate;
[M4 M4n ID4 N4]=motif4generate;
save motif34lib;

function [M Mn ID N]=motif3generate
n=0;
M=false(54,6);                  %isomorphs
CL=zeros(54,6,'uint8');         %predecessors of IDs
cl=zeros(1,6,'uint8');
N=zeros(54,1);                  %number of edges
G=zeros(3);
s=' '; zero='0';                %str2num characters
for i=0:2^6-1                   %loop through all subgraphs
    m=dec2bin(i);
    m=[num2str(zeros(1,6-length(m)), '%d') m];
    G=str2num ([ ...
        zero	s   m(3)	s	m(5) ;
        m(1)	s	zero	s	m(6) ;
        m(2)	s	m(4)	s	zero    ]);
    Ko=sum(G,2);
    Ki=sum(G,1).';
    if Ko+Ki,                   %if subgraph weakly-connected
        n=n+1;
        cl(:)=sortrows([Ko Ki]).';
        CL(n,:)=cl;             %assign motif label to isomorph
        M(n,:)=G([2:4 6:8]);
        N(n)=sum(G(:));
    end
end
[u1 u2 ID]=unique(CL,'rows');   %convert CL into motif IDs
[X ind]=sortrows([ID N]);       %sort motifs by IDs, number of edges
M=M(ind,:);
ID=ID(ind,:);
N=N(ind,:);
Mn=uint32(sum(repmat(10.^(5:-1:0),size(M,1),1).*M,2));  %single num. eqivalent of M

function [M Mn ID N]=motif4generate
n=0;
M=false(3834,12);               %isomorphs
CL=zeros(3834,16,'uint8');      %predecessor of IDs
cl=zeros(1,16,'uint8');
N=zeros(3834,1);                %number of edges
G=zeros(4);
s=' '; zero='0';                %str2num characters
for i=0:2^12-1                  %loop through all subgraphs
    m=dec2bin(i);
    m=[num2str(zeros(1,12-length(m)), '%d') m];
    G=str2num ([ ...
        zero	s   m(4)	s	m(7)	s	m(10) ;
        m(1)	s	zero	s	m(8)	s	m(11) ;
        m(2)	s	m(5)	s	zero	s	m(12) ;
        m(3)	s	m(6)	s	m(9)	s	zero    ]);
    Gs=G+G.';
    v=Gs(1,:); for j=1:2,
        v=any(Gs(v~=0,:),1)+v; end
    if v                        %if subgraph weakly connected
        n=n+1;
        G2=(G*G)~=0;
        Ko=sum(G,2);
        Ki=sum(G,1).';
        Ko2=sum(G2,2);
        Ki2=sum(G2,1).';
        cl(:)=sortrows([Ki Ko Ki2 Ko2]).';
        CL(n,:)=cl;             %assign motif label to isomorph
        M(n,:)=G([2:5 7:10 12:15]);
        N(n)=sum(G(:));
    end
end
[u1 u2 ID]=unique(CL,'rows');   %convert CL into motif IDs
[X ind]=sortrows([ID N]);       %sort motifs by IDs, number of edges
M=M(ind,:);
ID=ID(ind,:);
N=N(ind,:);
Mn=uint64(sum(repmat(10.^(11:-1:0),size(M,1),1).*M,2)); %single num. eqivalent of M