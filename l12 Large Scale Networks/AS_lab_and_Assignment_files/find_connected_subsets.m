function [subsets] = find_connected_subsets(CIJ,N,M)

% inputs:  
%           CIJ          connection matrix to be tested for motifs
%           N            size of CIJ
%           M            size of motif
% outputs: 
%           subsets      a list of all connected m-node subsets 
%
% Note: currently only works for m = 3, 4, 5
%
% Aviad Rubinstein, Indiana University, 2005
% =========================================================================

A = CIJ | CIJ';    % looks at both incoming and outgoing connections
edges = zeros(N,max(sum(A)));    % ith row of edges contains the indexes of nodes connected with node i  
for i=1:N
    edges(i,1:size(find(A(i,:)),2)) = find(A(i,:));
end
% initialize t to a fairly large number to avoid appending...
t = zeros(100000,M);  cnt = 0;

% make separate code for M=3, M=4, M=5

if (M==3)

    for i=1:N-M+1    % go through "first" node
        temp_edges1 = setdiff(edges(i,:),[0:i-1]);  % temp_edges<a> is the list of nodes connected to 
                                                    % the first a nodes in the subset that have not been
                                                    % checked yet.
        for j = 1:size(temp_edges1,2);    % go through "second" node
            temp_edges2 = setdiff(unique([temp_edges1(j+1:end) edges(temp_edges1(j),:)]),[0:i temp_edges1(1:j)]);
            szt2 = size(temp_edges2,2);
            % "third node"
                tri3 = [i.*ones(szt2,1) temp_edges1(j).*ones(szt2,1) temp_edges2'];
                cnt = cnt+szt2;  t(cnt-szt2+1:cnt,:) = tri3;
        end
    end
   
elseif (M==4)
    
    for i=1:N-M+1    % go through "first" node
        temp_edges1 = setdiff(edges(i,:),[0:i-1]);
        for j=1:size(temp_edges1,2)    % go through "second" node
            temp_edges2 = setdiff(unique([temp_edges1(j+1:end) edges(temp_edges1(j),:)]),[0:i temp_edges1(1:j)]);
            for k=1:size(temp_edges2,2)      % go through "third" node
                temp_edges3 = setdiff(unique([temp_edges2(k+1:end) edges(temp_edges2(k),:)]),[0:i temp_edges1(1:j), 0, temp_edges2(1:k)]);
                szt3 = length(temp_edges3);
                    % "fourth" node
                    tri4 = [repmat(i,szt3,1) repmat(temp_edges1(j),szt3,1) repmat(temp_edges2(k),szt3,1) temp_edges3'];  
                    cnt = cnt+szt3;  t(cnt-szt3+1:cnt,:) = tri4;        % add subsets to list
            end
        end
    end
    
elseif (M==5)
    
    for i=1:N-M+1    % go through "first" node
        temp_edges1 = setdiff(edges(i,:),[0:i-1]);
        for j=1:size(temp_edges1,2)    % go through "second" node
            temp_edges2 = setdiff(unique([temp_edges1(j+1:end) edges(temp_edges1(j),:)]),[0:i temp_edges1(1:j)]);
            for k=1:size(temp_edges2,2)    % go through "third" node
                temp_edges3 = setdiff(unique([temp_edges2(k+1:end) edges(temp_edges2(k),:)]),[0:i temp_edges1(1:j), 0, temp_edges2(1:k)]);
                for l=1:size(temp_edges3,2)      % go through "fourth" node
                    temp_edges4 = setdiff(unique([temp_edges3(l+1:end) edges(temp_edges3(l),:)]),[0:i temp_edges1(1:j), 0, temp_edges2(1:k), 0, temp_edges3(1:l)]);
                    szt4 = length(temp_edges4);
                        % "fifth" node
                        tri5 = [repmat(i,szt4,1) repmat(temp_edges1(j),szt4,1) repmat(temp_edges2(k),szt4,1) repmat(temp_edges3(l),szt4,1) temp_edges4'];  
                        cnt = cnt+szt4;  t(cnt-szt4+1:cnt,:) = tri5;        % add subsets to list
                end
            end
        end
    end

end

if (cnt>0) 
    subsets = sort(t(1:cnt,:),2);
end;

clear t edges A