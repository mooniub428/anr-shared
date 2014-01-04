%
function [grid] = vec12grid3(vector, nx, ny, nz)
    grid = zeros(nx, ny, nz);
    for i = 1 : nx
        for j = 1 : ny
            for k = 1 : nz
                grid(i, j, k) = vector((i - 1) * ny + (j - 1) * nz + k, 1);                                  
            end % for
        end % for
    end % for    
end % function