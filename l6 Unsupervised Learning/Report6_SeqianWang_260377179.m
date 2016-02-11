%% Report 6, Seqian Wang
%% In collaboration with Sulantha Mathotaarachchi and Maxime Parent

%% Part 1ab
kMeans

%% Part 1c
% Changed kMeans.m into a function with two outputs: the maxtrix X and the
% cluster indices (idx)
for k = [2 3 4 5]
    [X,idx] = kMeans(k);
    figure; silhouette(X,idx,'city');
    title(['Silhouette for k=' int2str(k)]);
    xlabel('Silhouette Value');
    ylabel('Cluster');
end

%% Part 2ab
% Changed g value in line 5 of simSTDPlatencies.m
Song2000_F4

%% Part 2c
Song2001_F1

%% Part 3abc
% Change noise by modifying third input
% Changes hopfield_net.m so that it output weights and memories
[w,s,~] = hopfield_net(100,'mem_ABC.txt',20,1);

%% Part 3d
lyapunov = (s'*w);
figure; plot(lyapunov);
title('Lyapunov function');
xlabel('states');
ylabel('energy');