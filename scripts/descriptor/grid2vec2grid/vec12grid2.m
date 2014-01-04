function [grid] = vec12grid2(vector)
    n = sqrt(size(vector, 1));
    grid = zeros(n, 2);
    for i = 1 : n
        for j = 1 : n
            grid(i, j) = vector((i - 1) * n + j, 1);                  
        end % for
    end % for
end % function