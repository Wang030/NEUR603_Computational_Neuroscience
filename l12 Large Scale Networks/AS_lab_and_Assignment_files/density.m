function [kden,N,K] = density(CIJ)

% input:  
%           CIJ  = connection/adjacency matrix
% output: 
%           kden = connection density, number of connections present out of all possible (N^2-N)
%           N    = number of vertices
%           K    = number of edges for the entire graph

% Note: Assumes that no self-connections exist.
% Note: CIJ must be entered as a square matrix.
%
% Olaf Sporns, Indiana University, 2002/2007

N = size(CIJ,1);
K = nnz(CIJ);
kden = K/(N^2-N);

