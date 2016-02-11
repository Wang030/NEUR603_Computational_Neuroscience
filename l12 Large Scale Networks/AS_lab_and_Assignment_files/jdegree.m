function [J,J_od,J_id,J_bl] = jdegree(CIJ)

% input
%         CIJ  = connection/adjacency matrix
% output
%         J    = joint degree distribution matrix (shifted by one)
%         J_od = number of vertices with od>id.
%         J_id = number of vertices with id>od.
%         J_bl = number of vertices with id=od.
%
% Olaf Sporns, Indiana University, 2002/2006
% =========================================================================

N = size(CIJ,1);

id = sum(CIJ,1);    % indegree = column sum of CIJ
od = sum(CIJ,2)';   % outdegree = row sum of CIJ

% Create the joint degree distribution matrix
% Note:  the matrix is shifted by one, to accomodate zero id and od.
% Upper triangular of the matrix has vertices with an excess of 
%    outgoing edges (od>id)
% Lower triangular of the matrix has vertices with an excess of 
%    outgoing edges (id>od)
% Main diagonal has units with id=od

szJ = max(max(id,od))+1;
J = zeros(szJ);

for i=1:N
   J(id(i)+1,od(i)+1) = J(id(i)+1,od(i)+1) + 1;
end;

J_od = sum(sum(triu(J)))-sum(diag(J));
J_id = sum(sum(tril(J)))-sum(diag(J));
J_bl = sum(diag(J));
