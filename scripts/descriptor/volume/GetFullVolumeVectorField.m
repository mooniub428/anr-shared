% Compute space-time volume filled with principal deformation axes;
% Volume size reflects characteristic scale of the interest point
%
function [Volume] = GetFullVolumeVectorField(LocalPatchFlat, Triangles, E, Frames, spaceStep, timeStep)
Volume = LocalPatchFlat; % init
numOfPoints = size(LocalPatchFlat.XYZ, 1);
numOfCentroids = size(LocalPatchFlat.XYZCentroid, 1);
numOfFrames = size(Frames, 2);

% Construct characteristic volume
Volume.XYZ = repmat(LocalPatchFlat.XYZ, numOfFrames, 1);
Volume.XYZCentroid = repmat(LocalPatchFlat.XYZCentroid, numOfFrames, 1);

counter = 1;
for fi = Frames
    % Construct new time coordinates
    Volume.XYZ((counter -1) * numOfPoints + 1 : counter * numOfPoints, 3) = (timeStep * fi) * ones(numOfPoints, 1);
    Volume.XYZCentroid((counter -1) * numOfCentroids + 1 : counter * numOfCentroids, 3) = (timeStep * fi) * ones(numOfCentroids, 1);
    
    % Compute new principal axes in time (with respect to changing
    % barycentric coordinates of them)
    if(fi == 1)
        Volume.PrincipalAxes((counter -1) * numOfCentroids + 1 : counter * numOfCentroids, 1:3) = zeros(numOfCentroids, 3);
    else
        LocalPatchWithAxesAtFrame = GetPrincipalAxesFromBarycentric(LocalPatchFlat, Triangles, E, fi);
        Volume.PrincipalAxes((counter -1) * numOfCentroids + 1 : counter * numOfCentroids, 1:3) = LocalPatchWithAxesAtFrame.PrincipalAxes;
        Volume.PrincipalAxes((counter -1) * numOfCentroids + 1 : counter * numOfCentroids, 3) = repmat(fi, numOfCentroids, 1);
    end % if
    counter = counter + 1;
end % for

% Shift to the center in time
Volume.XYZ(:, 3) = Volume.XYZ(:, 3) - mean(Volume.XYZ(:, 3)) * ones(numOfPoints * numOfFrames, 1);
Volume.XYZCentroid(:, 3) = Volume.XYZCentroid(:, 3) - mean(Volume.XYZCentroid(:, 3)) * ones(numOfCentroids * numOfFrames, 1);
upperMargin = max(Volume.XYZCentroid(:, 3));
Volume.upperMargin = upperMargin;

% Interpolate
Volume = Interpolate3PA(Volume, spaceStep, timeStep);
[qx, qy, qz] = vec32grid3(Volume.PrincipalAxes, Volume.nx, Volume.ny, Volume.nz);
quiver3(Volume.DensePointsX, Volume.DensePointsY, Volume.DensePointsZ, qx, qy, qz);
end % function