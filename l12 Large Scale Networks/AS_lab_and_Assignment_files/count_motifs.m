function [mf,upart] = count_motifs(CIJ,M)

% inputs:
%           CIJ       connection matrix
%           M         motif size (currently 2,3,4, or 5)
% outputs:
%           mf        motif frequency count
%           upart     unit participation in motifs
%
% The function assumes that CIJ is square and binary.  'mf' has counts for
% each motif class.  Requires input of compressed permuations of the motifs
% to look for.  The user can specify a subset of motifs in that file to
% restrict the search for only that class.
%
% Aviad Rubinstein, Olaf Sporns, Indiana University, 2005/2007
% =========================================================================

% load all compressed permutations of n-graphs of size M
load(['motifs',num2str(M),'a']);  

% initialize N, motif-frequency count and 'upart' array
N = size(CIJ,1);
mf = zeros(1,Mset);
upart = zeros(Mset,N);

% find connected subsets
[subsets] = find_connected_subsets(CIJ,N,M);

% if no subsets are found
if (prod(subsets)==0) 
    return; 
end;

% load compressed subgraphs
[subgraphs] = compress_subgraphs(CIJ,subsets,M);

% loop through all motifs
for i=1:Mset
    mind = find(motifs(:,2)==i);
    subgraph_occurrences = [];
    for m=1:length(mind)
        subgraph_occurrences = [subgraph_occurrences find(subgraphs==motifs(mind(m),1))];
    end;
    upart(i,:) = hist(nonzeros(subsets(subgraph_occurrences,:)),1:N);
end;

% derive mf from upart array
mf = sum(upart,2)'/M; 
