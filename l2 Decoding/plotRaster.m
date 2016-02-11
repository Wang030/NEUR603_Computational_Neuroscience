function plotRaster(r)

    [rows, cols] = size(r);

    k = 1;
    for i = size(r,1) : -1 : 1
        
        j = find(r(i,:) ~= 0);
        
        if ~isempty(j)
            for t = j

                plot([t t], [k k+1], 'w');
                %plot(t, k, '.', 'MarkerSize', 5);
                hold on;
            end
        end
        
        k = k + 1;
    end
    set(gca,'Color',[0 0 0]);
    axis([1 cols 1 rows]);
end