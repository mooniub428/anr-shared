function [vectorFromTheGrid] = grid32vec3(X, Y, Z)    
    nX = size(Y, 1);
    nY = size(Y, 2);
    nZ = size(Y, 3);
    
    vectorFromTheGrid = zeros(nX * nY * nZ, 3);
    indexPointer = 1;
    for i = 1 : nX
        for j = 1 : nY            
            for k = 1 : nZ
                 vectorFromTheGrid(indexPointer, :) = [X(i, j, k) Y(i, j, k) Z(i, j, k)];
                 indexPointer = indexPointer + 1;
            end % for
        end % for
    end % for
end % function