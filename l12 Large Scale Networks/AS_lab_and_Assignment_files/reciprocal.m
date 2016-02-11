function [RCIJ,rhoG] = reciprocal(CIJ)

% input:  
%           CIJ    = connection/adjacency matrix
% output: 
%           RCIJ   = CIJ matrix, with reciprocal connections labeled (set to 2)
%           rhoG   = fraction of all connections that are reciprocal, i.e. 
%                    fraction of all connections that "participate" in a 
%                    reciprocal connection.  For example, if there are three 
%                    connections total, two of which are reciprocal, 
%                    frecip = 2/3.
%
% Returns the original connection matrix with reciprocal edges set to 2.
% Note: 'rhoG' = 1 for all nondirected matrices
%
% Olaf Sporns, Indiana University, 2002/2007
% =========================================================================

% ensure CIJ is binary...
CIJ = double(CIJ~=0);

% find reciprocal edges
CIJr = CIJ+CIJ';
rhoG = 2*nnz(CIJr==2)/nnz(CIJr==1);
RCIJ = CIJ+(CIJr==2);
