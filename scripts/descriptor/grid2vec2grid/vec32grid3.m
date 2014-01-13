function [X, Y, Z] = vec32grid3(vector, nx, ny, nz )

X = zeros(nx, ny, nz);
Y = zeros(nx, ny, nz);
Z = zeros(nx, ny, nz);
    
for i = 1 : nx
    for j = 1 : ny
        for k = 1 : nz
            X(i, j, k) = vector((i - 1) * ny * nz + (j - 1) * nz + k, 1);                                             
            Y(i, j, k) = vector((i - 1) * ny * nz + (j - 1) * nz + k, 2); 
            Z(i, j, k) = vector((i - 1) * ny * nz + (j - 1) * nz + k, 3); 
        end % for
    end % for
end % for


end % function