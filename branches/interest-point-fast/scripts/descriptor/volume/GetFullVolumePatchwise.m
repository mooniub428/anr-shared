function [Volume] = GetFullVolumePatchwise(LocalPatchFlat, Triangles, E, orientation, Frames, spaceStep, timeStep)

Volume = LocalPatchFlat; % init
numOfPoints = size(LocalPatchFlat.XYZ, 1);
numOfCentroids = size(LocalPatchFlat.XYZCentroid, 1);
numOfFrames = size(Frames, 2);

% Construct characteristic volume
Volume.XYZ = repmat(LocalPatchFlat.XYZ, numOfFrames, 1);
Volume.XYZCentroid = repmat(LocalPatchFlat.XYZCentroid, numOfFrames, 1);

% Grid dimensions
gridNx = numel([-0.5 : spaceStep : 0.5]);

% Init new dense principal axes
Volume.DensePrincipalAxes = zeros(gridNx * gridNx * numOfFrames, 3);
% Init new densely sampled array of centroids
Volume.DenseXYZCentroid = zeros(gridNx * gridNx * numOfFrames, 3);

counter = 1;
for fi = Frames
    % Construct new time coordinates (increase value in time dimension for
    % each next frame
    Volume.XYZ((counter - 1) * numOfPoints + 1 : counter * numOfPoints, 3) = (timeStep * fi) * ones(numOfPoints, 1);
    Volume.XYZCentroid((counter - 1) * numOfCentroids + 1 : counter * numOfCentroids, 3) = (timeStep * (fi - 1) + timeStep) * ones(numOfCentroids, 1);
    
    % Compute new principal axes in time (with respect to changing
    % barycentric coordinates of them)
    LocalPatchWithAxesAtFrame = GetPrincipalAxesFromBarycentric(LocalPatchFlat, Triangles, E, fi);
    LocalPatchWithAxesAtFrame = TranslateRotateScaleVectorField(LocalPatchWithAxesAtFrame, orientation);
    
    LocalPatchWithAxesAtFrame = Interpolate2PA(LocalPatchWithAxesAtFrame, spaceStep);
    Volume.DenseXYZCentroid((counter - 1) * gridNx^2 + 1 : counter * gridNx^2, :) = LocalPatchWithAxesAtFrame.XYZCentroid;
    Volume.DenseXYZCentroid((counter - 1) * gridNx^2 + 1 : counter * gridNx^2, 3) = (timeStep * (fi - 1) + timeStep) * ones(gridNx^2, 1);
    
    Volume.DensePrincipalAxes((counter - 1) * gridNx^2 + 1 : counter * gridNx^2, :) = LocalPatchWithAxesAtFrame.DensePrincipalAxes;
    Volume.DensePrincipalAxes((counter - 1) * gridNx^2 + 1 : counter * gridNx^2, 3) = repmat( (fi - 1) * timeStep + timeStep, gridNx^2, 1);
    
    counter = counter + 1;
end % for

% Set dense grid dimensions of each patch
Volume.nx = LocalPatchWithAxesAtFrame.nx;
Volume.ny = LocalPatchWithAxesAtFrame.ny;
Volume.nz = numel(Frames);

% Set PrincipalAxes to be sub-sampled array of DensePrincipalAxes
Volume.PrincipalAxes = Volume.DensePrincipalAxes;
% Set XYZCentroid to be sub-sampled array of DenseXYZCentroid
Volume.XYZCentroid = Volume.DenseXYZCentroid;

% Shift to the center in time
%Volume.XYZ(:, 3) = Volume.XYZ(:, 3) - mean(Volume.XYZ(:, 3)) * ones(numOfPoints * numOfFrames, 1);
Volume.XYZCentroid(:, 3) = Volume.XYZCentroid(:, 3) - mean(Volume.XYZCentroid(:, 3)) * ones(gridNx * gridNx * numOfFrames, 1);
Volume.PrincipalAxes(:, 3) = Volume.PrincipalAxes(:, 3) - mean(Volume.PrincipalAxes(:, 3)) * ones(gridNx * gridNx * numOfFrames, 1);
upperMargin = max(Volume.XYZCentroid(:, 3));
Volume.upperMargin = upperMargin;

% Render vector field
[qx, qy, qz] = vec32grid3(Volume.PrincipalAxes, Volume.nx, Volume.ny, Volume.nz);
[DensePointsX, DensePointsY, DensePointsZ] = meshgrid(-0.5 : spaceStep : 0.5, ...
    -0.5 : spaceStep : 0.5, -upperMargin : timeStep : upperMargin + 0.01);
quiver3(DensePointsX, DensePointsY, DensePointsZ, qx, qy, qz);

end % function

