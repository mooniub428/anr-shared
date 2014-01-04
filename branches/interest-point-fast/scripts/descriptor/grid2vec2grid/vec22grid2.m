function [X, Y] = vec22grid2(vector, nx, ny)
    X = zeros(nx, ny);
    Y = zeros(nx, ny);
    for i = 1 : nx
        for j = 1 : ny
            X(i, j) = vector((i - 1) * nx + j, 1);
            Y(i, j) = vector((i - 1) * nx + j, 2);  
        end % for
    end % for
end % function
