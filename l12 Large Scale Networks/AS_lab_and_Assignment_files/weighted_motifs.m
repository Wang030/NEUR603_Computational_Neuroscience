function [upart_intens, upart_coherent, upart_count] = weighted_motifs(CIJ,M);
% finds motifs intensity in weighted, directed graphs
% weights should be on [0,1]
%
%%Modifications (Mika Rubinov) - July 2007%
%-Added upart_count: number of times a node participates in a motif
%   Obtain average intens[coher] via upart_intens[coherent]./upart_count
%-Commented out the MIN_EDGE condition:
%   I'm unsure of its purpose and it changes the results

tic

%% commented out by Mika - see above %%
% MIN_EDGE = 0.001 % This is important.
% % Edges below this weight are zeroed to allow non-full motifs to be counted:
% CIJ(CIJ < MIN_EDGE) = 0;

% load all compressed permutations n-graphs of size N
load(['motifs',num2str(M),'a']);

% initialize motif-frequency count
mf = zeros(1,Mset);

% create all subsets of nodes of length mpat out of CIJ
% Warning: this can be memory-extensive
% disp(['creating subsets ...']);
N = length(CIJ);
%[subsets] = find_connected_subsets_OS(CIJ,N,M);
subsets = nchoosek(1:size(CIJ,1),M);

time_to_find_connected_subsets = toc

[subgraphs, intensities, coherences] = compress_weighted(CIJ,subsets,M);   % load compressed subgraphs

time_to_compress_subgraphs = toc - time_to_find_connected_subsets

% initialize 'upart_intens' array, which records how many times each unit
% participates in a motif
upart_intens = zeros(Mset,N);
upart_coherent = zeros(Mset,N);
upart_count = zeros(Mset,N);

% loop through all distinct permutations of all m-graphs (motifs)
for i=1:size(motifs,1)

    subgraph_occurences = find(subgraphs==motifs(i));
    if subgraph_occurences,
        for j = 1:N;  % loops through all nodes to update upart_intens
            upart_intens(motifs(i,2),j) = upart_intens(motifs(i,2),j) + sum(intensities(subgraph_occurences(any(subsets(subgraph_occurences,:) == j,2))));
            upart_coherent(motifs(i,2),j) = upart_coherent(motifs(i,2),j) + sum(coherences(subgraph_occurences(any(subsets(subgraph_occurences,:) == j,2))));
            upart_count(motifs(i,2),j) = upart_count(motifs(i,2),j) + sum(any(subsets(subgraph_occurences,:) == j,2));
        end
    end
end;        % end loop 'm'

% mf = sum(upart_intens,2)'/M;
% mf_coherent = sum(upart_coherent,2)'/M;