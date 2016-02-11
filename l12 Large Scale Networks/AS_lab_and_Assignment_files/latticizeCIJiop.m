function  [CIJio,lowCIJcost,h,ord] = latticizeCIJiop(CIJ,H,cost)

% inputs:
%           CIJ         connection matrix
%           H           total number of successful swaps of two connections
%           cost        either 'line' or 'circ' or 'grps', for shape of lattice (linear or ring or group structure)
% outputs:
%           CIJio       latticized CIJ matrix, with in- and out-degree preserved
%           lowCIJcost  lowest cost
%           h           number of actual rewirings performed
%           ord         ordering of vertices used at the beginning
%
% This function "latticizes" a CIJ matrix by swapping connections while
% maintaining constant in-degree and out-degree.  No connections are made
% on the main diagonal. The desired total number of swaps is given by H,
% can be less ('h') if the rewiring reaches a state when no more progress
% towards lower cost is made.  'cost' determines the shape of the lattice.
%
% NOTE on output:  'CIJio' is the latticized matrix with matching
% in/out-degrees, although usually it may no look like a lattice - that is
% because of the random permutation of vertices at the beginning.  To
% display the optimally latticized matrix use 'CIJio(ord,ord)'.  Lattices
% may not be perfect, for two reasons: a) the optimization found a local
% solution; b) the input matrix CANNOT be perfectly latticized because of
% its degree structure.
%
% NOTE: Assumes N is even for now.  Function is SLOW. Use only for binary
% directed matrices.
%
% Follows (in principle) the approach by Maslov and Sneppen, 2002.
%
% Olaf Sporns, Indiana University, 2005/2007.
% =======================================================================

N = length(CIJ);
h = 0;
pow2 = [8 4 2 1];
cnt_reverse = 0;
cnt_thr = N^2;   % may need to be adjusted by hand

% begin by permuting the order of the nodes
CIJorig = CIJ;
ord = randperm(N);
CIJ = CIJorig(ord,ord);

% generate cost function
if (cost=='line');
    profil = fliplr(normpdf([1:N],0,N/4));
    COST = toeplitz(profil,profil);
end;
if (cost=='circ');
    profil = fliplr(normpdf([1:N],N/2,N/4));
    COST = toeplitz(profil,profil);
end;
if (cost=='grps');
    g1 = N-ceil(N/2)+2; g2 = N-g1;
    COST = [zeros(g1) ones(g1,g2); ones(g2,g1) zeros(g2)];
end;

% initialize lowCOST
lowCIJcost = sum(sum(COST.*CIJ));

while h<H

    % rewire (as for randomize)
    rp = randperm(N);
    b = CIJ([rp(1) rp(2)],[rp(3) rp(4)]);
    subgraph = sum(b(1:4).*pow2);

    % if the graph is being rewired
    if ((subgraph==6)|(subgraph==9))

        % rewire
        if (subgraph==6) CIJ([rp(1) rp(2)],[rp(3) rp(4)]) = [1 0; 0 1]; end;
        if (subgraph==9) CIJ([rp(1) rp(2)],[rp(3) rp(4)]) = [0 1; 1 0]; end;

        % new cost after rewiring
        CIJcost = sum(sum(COST.*CIJ));

        % if cost has increased, reverse the swap and don't count
        if (CIJcost>lowCIJcost)
            if (subgraph==6) CIJ([rp(1) rp(2)],[rp(3) rp(4)]) = [0 1; 1 0]; end;
            if (subgraph==9) CIJ([rp(1) rp(2)],[rp(3) rp(4)]) = [1 0; 0 1]; end;
            cnt_reverse = cnt_reverse+1;

            % ... otherwise it's a keeper
        else
            lowCIJcost = CIJcost;
            h = h+1;
            cnt_reverse = 0;
        end;
    end;

    % emergency brake: terminate if more than 'cnt_thr' rewirings were
    % unsuccessful in lowering the cost
    if (cnt_reverse>cnt_thr)
        % reverse initial reordering
        [valord,revord] = sort(ord);
        CIJio = CIJ(revord,revord);
        disp('hello');
        return;
    end;

end;

% reverse initial reordering
[valord,revord] = sort(ord);
CIJio = CIJ(revord,revord);
