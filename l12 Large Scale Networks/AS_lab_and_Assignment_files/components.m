function  [strconn,mulcomp,ncomps,ind_comps,siz_comps] = components(CIJ,R);

% input:  R         = reachability matrix
% output: ncomps    = number of distinct components
%         ind_comps = indices of components
%         siz_comps = sizes of components (use to unpack 'ind_comps')

% Note: operates on the reachability matrix, finds multiple components
% Indices are indices of R

% Written by Olaf Sporns, Indiana University, 2002

N = size(CIJ,1);

% Determine if entire graph is strongly connected
if (sum(sum(R==1))==N^2) strconn = 1;
else strconn = 0; end;

% Determine if the graph has multiple strongly connected components.
% IF R is symmetrical 
% AND not strongly connected 
% AND CIJ is not trivially empty
if ((R==R')&(strconn==0)&(sum(sum(R)>0)==size(R,1))) 
   mulcomp = 1;
else 
   mulcomp = 0; 
end;

% Check for vertices that have no incoming or outgoing connections.
% These are "ignored" by 'reachdist'.
id = sum(CIJ,1);       % indegree = column sum of CIJ
od = sum(CIJ,2)';      % outdegree = row sum of CIJ
id_0 = find(id==0);    % nothing goes in, so column(R) will be 0
od_0 = find(od==0);    % nothing comes out, so row(R) will be 0
% Use these columns and rows to check for reachability:
col = setxor(1:N,id_0);
row = setxor(1:N,od_0);
all = setxor(1:N,(setxor(col,row)));

% Check how many unique and strong components there are, 
% excluding vertices that have no incoming or outgoing connections.
Rstrong = R(all,all);
comps = unique(Rstrong,'rows');
ncomps = size(comps,1);

% loop over components and find sizes and indices
ind_comps = [];
siz_comps = [];
for c=1:ncomps
   ind = find(comps(c,:));
%   ind_comps = [ind_comps ind];
   ind_comps = [ind_comps all(ind)];
   siz_comps = [siz_comps length(ind)];
end;
