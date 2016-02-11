function  [CIJio,ord] = randomizeCIJiop_nondir(CIJ,H)

% inputs:
%           CIJ       connection matrix
%           H         total number of swaps of two connections
% outputs:
%           CIJio     randomized CIJ matrix, with preserved in- and out-degree
%           ord       order of vertices that was used in permutation
%
% This function randomizes a CIJ matrix by swapping connections while
% maintaining a constant in-degree and out-degree distribution.  No
% connections are made on the main diagonal. Swaps that involve the main
% diagonal of the matrix are excluded by making unique choices for all 4
% positions (it is unknown if this has any impact on the statistics...).
% The total number of swaps is given by 'H'.  Follows (in principle) the
% approach by Maslov and Sneppen, 2002.
%
% Use only for binary nondirected (symmetrical) matrices
%
% Olaf Sporns, Indiana University, 2007
% =========================================================================

N = length(CIJ);
h = 0;
pow2 = [8 4 2 1];
h = 0;

% begin by permuting the order of the nodes
CIJorig = CIJ;
ord = randperm(N);
CIJ = CIJorig(ord,ord);

% perform 'H' swaps total, use rand instead of randperm for faster
% performance, unique elements in 'rp' must be assured
while h<H
    rp = ceil(rand(4,1).*N);
    b = CIJ([rp(1) rp(2)],[rp(3) rp(4)]);
    if ((nnz(diff(sort(rp)))==3)&&(nnz(b)==2))   % checks for unique elements in rp
        subgraph = sum(b(1:4).*pow2);
        if (subgraph==6)
            CIJ([rp(1) rp(2)],[rp(3) rp(4)]) = [1 0; 0 1];
            CIJ([rp(3) rp(4)],[rp(1) rp(2)]) = [1 0; 0 1];
            h = h+1;
        end;
        if (subgraph==9)
            CIJ([rp(1) rp(2)],[rp(3) rp(4)]) = [0 1; 1 0];
            CIJ([rp(3) rp(4)],[rp(1) rp(2)]) = [0 1; 1 0];
            h = h+1;
        end;
    end;
end;

% reverse initial reordering
[iii,revord] = sort(ord);
revord = revord';
CIJio = CIJ(revord,revord);
