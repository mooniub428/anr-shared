% Densely interpolate principal deformation axes within flattened surface
% patch
function [DenseLocalPatchFlat] = Interpolate2PA(LocalPatchFlat, spaceStep)     
	DenseLocalPatchFlat = LocalPatchFlat; % init
    SparsePoints = LocalPatchFlat.XYZCentroid(:, 1:2);
    v = -0.5 : spaceStep : 0.5;
    [DensePointsX, DensePointsY] = meshgrid(v);
    
    % Dimensions of the dense grid 
    DenseLocalPatchFlat.nx = size(DensePointsX, 1); % the same as size(DensePointsX, 2)
    DenseLocalPatchFlat.ny = size(DensePointsY, 1); % size(DensePointsY, 2)
         
    [x,y,z] = rbf(SparsePoints(:, 1), SparsePoints(:, 2), LocalPatchFlat.PrincipalAxes(:, 1), DensePointsX, DensePointsY, 'multiquadratic');
    InterpolatedData = grid32vec3(x, y, z);
    InterpolatedPrincipalAxeX = InterpolatedData(:, 3);
        
    % Interpolate y components    
    [x,y,z] = rbf(SparsePoints(:, 1), SparsePoints(:, 2), LocalPatchFlat.PrincipalAxes(:, 2), DensePointsX, DensePointsY, 'multiquadratic');
    InterpolatedData = grid32vec3(x, y, z);
    InterpolatedPrincipalAxeY = InterpolatedData(:, 3);        

    %DensePrincipalAxes = grid22vec2(DensePrincipalAxesX, DensePrincipalAxesY);         
     
    DenseLocalPatchFlat.v = v;
    XYZCentroid = grid22vec2(DensePointsX, DensePointsY);
    DenseLocalPatchFlat.XYZCentroid = [XYZCentroid zeros(size(InterpolatedPrincipalAxeY, 1), 1)];
    DenseLocalPatchFlat.DensePrincipalAxes = [InterpolatedPrincipalAxeX InterpolatedPrincipalAxeY zeros(size(InterpolatedPrincipalAxeY, 1), 1)];
end % function