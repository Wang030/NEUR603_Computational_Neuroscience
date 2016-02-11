%
% 2008 03 27 Matlab assignment
%

%% 0

%% 1

load macaque71;
whos
  
h1 = figure(1);
imagesc(CIJ)
colormap(hot)
colorbar
title('Connectivity matrix of monkey cortex');

Names

[N1 N2] = size(CIJ);

N = N1

K = sum(CIJ(:))


%% 2

[CIJ_rand_io,ord] = randomizeCIJiop(CIJ,0);

h2 = figure(2);
imagesc(CIJ_rand_io)
colormap(hot)
colorbar
title('Connectivity matrix of monkey cortex, 0 connections randomized');
pause

[CIJ_rand_io,ord] = randomizeCIJiop(CIJ,249);

h2 = figure(2)
imagesc(CIJ_rand_io)
colormap(hot)
colorbar
title('Connectivity matrix of monkey cortex, 249 (~ 1/3 of) connections randomized');

sum(CIJ_rand_io(:))


%% 3

N
K

[CIJ_rand] = makerandCIJ(N,K);

h3 = figure(3)
imagesc(CIJ_rand)
colormap(hot)
title('Connectivity matrix, random');

%% 4

[CIJ_lattice] = makelatticeCIJ(N,K);

h4 = figure(4);
imagesc(CIJ_lattice)
colormap(hot)
title('Connectivity matrix, lattice: 71 areas, 746 connections');
pause

[CIJ_lattice] = makelatticeCIJ(N,70*2);

h4 = figure(4);
imagesc(CIJ_lattice)
colormap(hot)
title('Connectivity matrix, lattice: 71 areas, 140 connections');

%% 5

[kden,N,K] = density(CIJ)

%% 6

[id,od,deg] = degrees(CIJ)

h5 = figure(5)
plot(id,'r')
hold;
plot(od,'g')
plot(deg,'b')
title('In (r), out (g), and both (b) degrees');


%% 7

[gamma,gammaG] = clustcoef(CIJ)

h6 = figure(6)
plot(gamma,'k');
title('Clustering index (k)');
pause

h7 = figure(7)
plot(deg, gamma, '*');
title('Clustering index as a function of degree of connectivity');

%%