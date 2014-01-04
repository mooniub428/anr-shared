function [vectorFromTheGrid] = grid22vec2(X, Y)
    nX = size(Y, 1);
    nY = size(Y, 2);
    vectorFromTheGrid = zeros(nX * nY, 2);
    
    indexPointer = 1;
    for i = 1 : nX
        for j = 1 : nY
            %vectorFromTheGrid((i - 1) * n + j, :) = [X(i, j) Y(i, j)];v
            vectorFromTheGrid(indexPointer, :) = [X(i, j) Y(i, j)];
            indexPointer = indexPointer + 1;
        end % for
    end % for
end % function

