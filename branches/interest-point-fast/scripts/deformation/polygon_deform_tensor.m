function [E, D] = polygon_deform_tensor(v, v_hat)

n_poly_vert = size(v, 1);

v1 = v(1, :)';
v2 = v(2, :)';
v3 = v(3, :)';
v1_ = v_hat(1, :)';
v2_ = v_hat(2, :)';
v3_ = v_hat(3, :)';

n = cross(v2-v1, v3-v1); 
tmpVal=unique(n);
if length(tmpVal)==1 && tmpVal==0
    E = eye(3,3);
    D = eye(3,3);
else
    v4 = v1 + n/norm(n);    % 4th point above the triangle. From the 'Deformation Transfer' paper.
    %v4 = v1 + n/sqrt(norm(n));    % 4th point above the triangle. From the 'Deformation Transfer' paper.

    n_ = cross(v2_-v1_, v3_-v1_); 
    v4_ = v1_ + n_/norm(n_); % 4th point above the triangle. From the 'Deformation Transfer' paper.
    %v4_ = v1_ + n_/sqrt(norm(n_));
    
    V1 = repmat(v1, 1, n_poly_vert);
    V = [v(2 : n_poly_vert, :)' v4] - V1;
    V_hat = [v_hat(2 : n_poly_vert, :)' v4] -V1;
    
    F = V_hat * pinv(V);    % F (deformation gradient tensor) contains rotation and stretch.
    
    % C (right Cauchy deformation tensor), is symmetric, and is the square of the right stretch tensor.
    C = F' * F;

    C1 = sqrtm(C);
    
    [E,D] = eig(C1); % E: eigenvectors, D: eigenvalues
end

end % function

