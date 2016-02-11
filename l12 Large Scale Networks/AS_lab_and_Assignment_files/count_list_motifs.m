function [mf,upart,ml,mc] = count_list_motifs(CIJ,M)

% inputs:
%           CIJ       connection matrix
%           M         motif size (currently 2,3,4, or 5)
% outputs:
%           mf        motif frequency count
%           upart     unit participation in motifs
%           ml        motif list, a list of all motifs
%           mc        motif class for all motifs found

% The function assumes that CIJ is square and binary.  'mf' has counts for
% each motif class.  Requires input of compressed permuations of the motifs
% to look for.  The user can specify a subset of motifs in that file to
% restrict the search for only that class.
%
% This function is substantially identical to 'count_motifs', but also in
% addition provides a list of all motifs found and their participating
% vertices.
%
% Aviad Rubinstein, Olaf Sporns, Indiana University, 2005/2007
% =========================================================================

% load all compressed permutations of n-graphs of size M
load(['motifs',num2str(M),'a']);  

% initialize N, motif-frequency count and 'upart' array
N = length(CIJ);
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

% loop through all distinct permutations of all m-graphs (motifs)
ml = [];  mc = [];
for i=1:size(motifs,1)
    subgraph_occurrences = find(subgraphs==motifs(i));
    ml = [ml; subsets(subgraph_occurrences,:)];
    mc = [mc; ones(length(subgraph_occurrences),1).*motifs(i,2)];
    for j=1:N  % loops through all nodes to update upart   
        upart(motifs(i,2),j) = upart(motifs(i,2),j) + length(find(subsets(subgraph_occurrences,:) == j));
    end;
end;

% derive mf from upart array
mf = sum(upart,2)'/M; 
