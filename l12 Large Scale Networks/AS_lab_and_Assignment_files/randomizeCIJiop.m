function  [CIJio,ord] = randomizeCIJiop(CIJ,H)

% inputs:
%           CIJ       connection matrix 
%           H         total number of swaps of
%                     two connections
% outputs:
%           CIJio     randomized CIJ matrix, with preserved in- and
%                     out-degree 
%           ord       permutation order chosen at the beginning
%                     of the randomization
%
% This function randomizes a CIJ matrix by swapping connections while
% maintaining a constant in-degree and out-degree distribution.  No
% connections are made on the main diagonal. Main diagonal swaps are
% excluded by making unique choices for all 4 positions. The total number
% of swaps is given by H. Vertices are randomly permuted at the start to
% generate random initial conditions - at the end, vertices are placed back
% into their original positions. Follows the approach by Maslov and Sneppen
% (2002) and Milo et al. (2002).
%
% Use only for binary directed matrices
%
% Olaf Sporns, Indiana University, 2005/2007
% =========================================================================

N = length(CIJ);
h = 0;
pow2 = [8 4 2 1];
h = 0;

% begin by permuting the order of the vertices
CIJorig = CIJ;
ord = randperm(N);
CIJ = CIJorig(ord,ord);

while h<H
    rp = ceil(rand(4,1).*N);
    b = CIJ([rp(1) rp(2)],[rp(3) rp(4)]);
    if ((nnz(diff(sort(rp)))==3)&&(nnz(b)==2))   % checks for unique elements in rp
        subgraph = sum(b(1:4).*pow2);
        if (subgraph==6)
            CIJ([rp(1) rp(2)],[rp(3) rp(4)]) = [1 0; 0 1];
            h = h+1;
        end;
        if (subgraph==9)
            CIJ([rp(1) rp(2)],[rp(3) rp(4)]) = [0 1; 1 0];
            h = h+1;
        end;
    end;
end;

% reverse initial permuted reordering
[valord,revord] = sort(ord);
CIJio = CIJ(revord,revord);
