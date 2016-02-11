function [deg] = degrees_nondir(CIJ)

% input:  
%         CIJ  = connection/adjacency matrix
% output: 
%         deg  = degree for all vertices
%
% Computes the degree for a nondirected binary matrix.
%
% Olaf Sporns, Indiana University, 2002/2006
% =========================================================================

% ensure CIJ is binary...
CIJ = double(CIJ~=0);

deg = sum(CIJ);        % degree = indegree+outdegree

