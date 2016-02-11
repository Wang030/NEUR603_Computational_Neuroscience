function [ w, s, results2 ] = hopfield_net(nsize,memf,noiseLevel,doScale) %memtestf
% Simple implementation of Hopfield network
%
% example: hopfield_net(100,'mem_CA3.txt')
%
% nsize: pattern size
% memf: filename with patterns [n*nsize,nsize]
% noiseLevel: inverts this percentage number of bits
%
% results: hamming distance between original patterns and recovered ones

    close all;
    
    w = zeros(nsize,nsize);     % weight matrix [size][size]
    mem = load(memf);           % Load memories from file
    
    if doScale
        mem = (mem/255-0.5)*2;
    end

    mem = reshape(mem',size(mem,2)*size(mem,2),size(mem,1)/size(mem,2));
    
    % Calculate the weights (simple Hebbian rule)
    for i=1:nsize
        for j=i:nsize
            waux = 0;
            for m=1:size(mem,2)
                waux = waux + mem(i,m)*mem(j,m);
            end
            waux = waux/size(mem,2);        % JSj
            w(i,j) = waux;
            w(j,i) = waux;
        end
        w(i,i) = 0;                         % JSj, no self-connections, to satisfy Lyapunov function
    end

    % Generate test patterns by adding noise
    results1 = zeros(1,size(mem,2));
    mem_test = zeros(nsize,size(mem,2));
    p_val = noiseLevel/100;
    countReplacements = 0;
    
    for i=1:size(mem,2)
        for j=1:size(mem,1)
            if (rand<p_val)
                mem_test(j,i) = -mem(j,i);
                countReplacements = countReplacements+1;
            else
                mem_test(j,i) = mem(j,i);
            end
        end
        % Distance to original patterns
        results1(i) = hamming_distance(mem_test(:,i), mem(:,i));
    end
    disp(['Number of replaced bits: ' num2str(countReplacements)]);
    disp(['Hamming distances from noisy version to original patterns: ' num2str(results1)])
    
    % Recall original memory
    results2 = zeros(1,size(mem,2));
    mem_rec = zeros(nsize,size(mem,2));
    mem_work = mem_test;
    for m=1:size(mem_test,2)
        s = zeros(nsize,1);
        s_old = ones(nsize,1);
        n_iters = 0;
        while true
            for i=1:nsize
                waux = 0;
                for j=1:nsize
                    waux = waux + w(i,j)*mem_work(j,m);
                end
                s(i) = waux;
            end
            s(s > 0) = 1;
            s(s < 1) = -1;
            mem_work(:,m) = s;
            n_iters = n_iters + 1;
            if all(s_old == s)          % Iterate until convergence
                break
            end
            s_old = s;
        end
        disp(['For memory ' num2str(m) ', ' num2str(n_iters) ' iterations']);
        % Distance to original patterns
        results2(m) = hamming_distance(s, mem(:,m));
        mem_rec(:,m) = s;
    end
    disp(['Hamming distances from recalled versions to original patterns: ' num2str(results2)])
    %{
    %Plot all combinations
    figure;
    for i = 0:2^size(mem,2)-1
        subplot(size(mem,2),size(mem,2),i+1);
        s1 = (double(bitget(uint8(i),1))-0.5)*2;
        s2 = (double(bitget(uint8(i),2))-0.5)*2;
        s3 = (double(bitget(uint8(i),3))-0.5)*2;
        combo = (reshape(mem(:,1), sqrt(size(mem,1)), sqrt(size(mem,1)))')*s1 + ...
            (reshape(mem(:,2), sqrt(size(mem,1)), sqrt(size(mem,1)))')*s2 + ...
            (reshape(mem(:,3), sqrt(size(mem,1)), sqrt(size(mem,1)))')*s3;
        combo(combo > 0) = 1;
        combo(combo < 0) = -1;
        imagesc(combo);
    end 
    colormap(gray);
    %}
 
    %Plot original patterns
    figure;
    for i = 1:size(mem,2)
        subplot(size(mem,2),size(mem,2),i);
        imagesc(reshape(mem(:,i), sqrt(size(mem,1)), sqrt(size(mem,1)))');
        if(i==round(size(mem_rec,2)/2))
            title('Original Patterns', 'fontsize', 12);
        end
    end 
    colormap(gray);
    
    %Plot corrupted patterns
    for i = 1:size(mem_test,2)
        subplot(size(mem,2),size(mem,2),i+size(mem,2));
        imagesc(reshape(mem_test(:,i), sqrt(size(mem_test,1)), sqrt(size(mem_test,1)))');
        if(i==round(size(mem_rec,2)/2))
            title('Corrupted Patterns', 'fontsize', 12);
        end
    end
    
    %Plot recovered patterns
    for i = 1:size(mem_rec,2)
        subplot(size(mem,2),size(mem,2),i+size(mem,2)*2);
        imagesc(reshape(mem_rec(:,i), sqrt(size(mem_rec,1)), sqrt(size(mem_rec,1)))');
        if(i==round(size(mem_rec,2)/2))
            title('Recovered Patterns', 'fontsize', 12);
        end    
    end
    set(gcf, 'Color', 'w');
end

