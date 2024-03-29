% Hyewon SEO, (C) 2013
% Computes a deformation measure of the given triangle using maximum or minimum strain.
% These strains are computed from Deformation Gradient Tensor, named as 'F'
% below. Sumner et al [2004] used 'Q' to denote the same matrix. 
% 
function [E, D] = local_strain_tensor(v, v_hat)

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
    
    V =     [v2-v1     v3-v1      v4-v1];
    V_ =    [v2_-v1_  v3_-v1_    v4_-v1_];
    F = V_ * inv(V);    % F (deformation gradient tensor) contains rotation and stretch.

    % C (right Cauchy deformation tensor), is symmetric, and is the square of the right stretch tensor.
    C = F' * F;

    C1 = sqrtm(C);
    
    [E,D] = eig(C1); % E: eigenvectors, D: eigenvalues
end

%{
function [deform_measure] = method_DGT(v1,v2,v3, v1_, v2_, v3_)

n = cross(v2-v1, v3-v1); 
tmpVal=unique(n);
if length(tmpVal)==1 && tmpVal==0
    deform_measure=0;
else
    v4 = v1 + n/norm(n);    % 4th point above the triangle. From the 'Deformation Transfer' paper.

    n_ = cross(v2_-v1_, v3_-v1_); 
    v4_ = v1_ + n_/norm(n_); % 4th point above the triangle. From the 'Deformation Transfer' paper.

    V =     [v2-v1     v3-v1      v4-v1];
    V_ =    [v2_-v1_  v3_-v1_    v4_-v1_];
    F = V_ * inv(V);    % F (deformation gradient tensor) contains rotation and stretch.

    % C (right Cauchy deformation tensor), is symmetric, and is the square of the right stretch tensor.
    C = F' * F;

    [E,D] = eig(C); % E: eigenvectors, D: eigenvalues
    stretch = max(diag(D));
    shrink = min(diag(D));
    
    shrink_2_stretch = 1/shrink;
    epsilon = 1e-3;
    assert(stretch >= 1-epsilon);
    assert(shrink_2_stretch >= 1-epsilon);
    
    lamda1 = sqrt(stretch) - 1;
    lamda2 = sqrt(shrink_2_stretch) - 1;
    
    deform_measure = lamda1 + lamda2;
%    deform_measure = abs(stretch)+abs(shrink_2_stretch);
%    deform_measure_ = abs(stretch)*abs(shrink_2_stretch);
end


function [deform_measure, E, D] = method_DGT(v1,v2,v3, v1_, v2_, v3_)

n = cross(v2-v1, v3-v1); 
tmpVal=unique(n);
if length(tmpVal)==1 && tmpVal==0
    deform_measure=0;
    E = eye(3,3);
    D = eye(3,3);
else
    v4 = v1 + n/norm(n);    % 4th point above the triangle. From the 'Deformation Transfer' paper.

    n_ = cross(v2_-v1_, v3_-v1_); 
    v4_ = v1_ + n_/norm(n_); % 4th point above the triangle. From the 'Deformation Transfer' paper.

    V =     [v2-v1     v3-v1      v4-v1];
    V_ =    [v2_-v1_  v3_-v1_    v4_-v1_];
    F = V_ * inv(V);    % F (deformation gradient tensor) contains rotation and stretch.

    % C (right Cauchy deformation tensor), is symmetric, and is the square of the right stretch tensor.
    C = F' * F;

    [E,D] = eig(C); % E: eigenvectors, D: eigenvalues
    stretch = max(diag(D));
    shrink = min(diag(D));
    
    shrink_2_stretch = 1/shrink;
    epsilon = 1e-3;
    assert(stretch >= 1-epsilon);
    assert(shrink_2_stretch >= 1-epsilon);
    
    lamda1 = sqrt(stretch) - 1;
    lamda2 = sqrt(shrink_2_stretch) - 1;
    
    deform_measure = lamda1 + lamda2;
    
%    deform_measure = abs(stretch)+abs(shrink_2_stretch);
%    deform_measure_ = abs(stretch)*abs(shrink_2_stretch);
end
%}