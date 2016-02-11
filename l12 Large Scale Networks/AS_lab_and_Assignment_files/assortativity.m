function   r = assortativity(CIJ,flag)

% inputs:
%               CIJ       connection matrix
%               flag      1 = directed graph; 0 = non-directed graph
% outputs:
%               r         assortativity
%
% assortativity, computed after Newman (2002)
%
% Olaf Sporns, Indiana University, 2007
%
% =========================================================================

if (flag==0)
    K = length(nonzeros(CIJ))/2;
    [deg] = degrees_nondir(CIJ);
end;
if (flag==1)
    K = length(nonzeros(CIJ));
    [id,od,deg] = degrees(CIJ);
end;

% record degrees for each edge of the network
[i,j] = find(CIJ>0);
for k=1:K
    degi(k) = deg(i(k));
    degj(k) = deg(j(k));
end;

% compute assortativity
r = (sum(degi.*degj)/K - (sum(0.5*(degi+degj))/K)^2)/ ...
    (sum(0.5*(degi.^2+degj.^2))/K - (sum(0.5*(degi+degj))/K)^2);

