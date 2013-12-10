function [Res] = get_vector_field( trgVertices, refVertices, refTriangles, eigenIndex )

addpath('Tools');
countTriangles = size(refTriangles, 1);
%countTriangles= 400;
startTi = 0;

Res = zeros(countTriangles, 6);

for i = 1  : countTriangles
    ti = startTi + i;
    refTri = refVertices(refTriangles(ti, :), :);
    trgTri = trgVertices(refTriangles(ti, :), :);
    %[E, D] = GetStrain( refTri(1, :)', refTri(2, :)', refTri(3, :)', trgTri(1, :)', trgTri(2, :)', trgTri(3, :)' );
    [E, D] = local_strain_tensor(refTri, trgTri);
    Barycenter = mean(trgTri);
    Barycenter = mean(refTri);
    Res(i, 1:3) = Barycenter;
    
    eps = 0.01;
    Dd = abs(diag(D));
    Dd(find(Dd - 1.0 < eps)) = 0.0;
    
%     for j = 1 : 3
%         for k = 1 : 3
%             if (abs(D(j, k) - 1.0) < eps)
%                 D(j, k) = 0;
%             end % if
%         end % for
%     end % for
    
    %A = E * D; % Columns are eigen vectors
   
    
    %Res(i, 4:6) = A(:, (4 - eigenIndex))';
    Res(i, 4:6) = Dd(eigenIndex) * E(:, eigenIndex)';   
    %Res(i, 4:6) = newVec;
end % for


end % function

