% Compute 2d radial histogram descriptor based on surface deformation
% principal axes
function [Histograms] = DescriptorPrincipalAxes(Vertices, Triangles, E, Adj, vi, fi, sigma, tau, param)
    % Get local triangle patch around the interest point
    [LocalPatch, Frames] = GetTriPatch(Vertices, Triangles, Adj, vi, sigma, tau);
    
    % Flatten vertices within the patch    
    XY = pca([LocalPatch.XYZ; LocalPatch.XYZCentroid], 2);
    numOfPoints = size(LocalPatch.XYZ, 1);
    numOfCentr = size(XY, 1) - numOfPoints;
    LocalPatchFlat = LocalPatch;
    LocalPatchFlat.XYZ = [XY(1 : numOfPoints, :) zeros(numOfPoints, 1)];     
    LocalPatchFlat.XYZCentroid = [XY(numOfPoints + 1 : numOfPoints + numOfCentr, :) zeros(numOfCentr, 1)];     
    
    spaceStep = 0.1;
    timeStep = 0.2;
    
    % Compute principal directions with respect to their barycentric
    % coordinates LocalPatchFlat.PrincipalAxes
    LocalPatchFlat = GetPrincipalAxesFromBarycentric(LocalPatchFlat, Triangles, E, fi);
    TranslateRotateScaleVectorField(LocalPatchFlat, [1 0 0]);
    Vectors2MaxscriptSplines(LocalPatchFlat.XYZCentroid, LocalPatchFlat.XYZCentroid + LocalPatchFlat.PrincipalAxes);
    DenseLocalPatchFlat = Interpolate2(LocalPatchFlat, spaceStep);
    
    % Get dominant orientation with respect to gradients of surfaces
    % deformation values
    numOfBins = 18;
    orientation = GetOrientationVectorField(DenseLocalPatchFlat, numOfBins, spaceStep);

    LocalPatchFlat = TranslateRotateScaleVectorField(LocalPatchFlat, orientation);
        
    [Volume] = GetFullVolumeVectorField(LocalPatchFlat, Triangles, E, Frames, spaceStep, timeStep);
            
    Histograms = GetHistogramsOfPrincipalAxes(Volume, numOfBins);  
    Histograms = InterpolateAllHistograms(Histograms);
end % function

%%
% Compute space-time volume filled with principal deformation axes;
% Volume size reflects characteristic scale of the interest point
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

% Densely interpolate principal deformation axes within flattened surface
% patch
function [DenseLocalPatchFlat] = Interpolate2(LocalPatchFlat, spaceStep)     
	DenseLocalPatchFlat = LocalPatchFlat; % init
    SparsePoints = LocalPatchFlat.XYZCentroid(:, 1:2);
    v = -0.5 : spaceStep : 0.5;
    [DensePointsX, DensePointsY] = meshgrid(v);
    
     % Do good RBF interpolation
     % Interpolate x components
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

% Compute principal strain axes in a flattened patch out of their
% barycentric coordinates in non-flattened patch
function [LocalPatchFlat] = GetPrincipalAxesFromBarycentric(LocalPatchFlat, Triangles, E, fi);
	numOfTriangles = size(LocalPatchFlat.TriID, 2);
	
	LocalPatchFlat.PrincipalAxes = zeros(numOfTriangles, 3);
	for i = 1 : numOfTriangles
		TriangleVertexIDs = Triangles(LocalPatchFlat.TriID(i), :);
		CorrectVertexIDs = zeros(3, 1);
		for j = 1 : 3			
			nextVertexId = TriangleVertexIDs(j);
			CorrectVertexIDs(j) = find(LocalPatchFlat.VertID == nextVertexId);
		end % for
		BarCoord = cell2mat(E(LocalPatchFlat.TriID(i), fi));
		LocalPatchFlat.PrincipalAxes(i, :) = Barycentric2Cartesian(BarCoord, ...
		LocalPatchFlat.XYZ(CorrectVertexIDs, :));
        %
        LocalPatchFlat.PrincipalAxes(i, :) = LocalPatchFlat.PrincipalAxes(i, :) + ...
            LocalPatchFlat.XYZCentroid(i, :);
	end % for
end % function

function [LocalPatch, Frames] = GetTriPatch(Vertices, Triangles, AdjMatrix, vi, sigma, tau)    
    % First, get vertex n-ring around interest point at characteristic scale
    numOfRings = 1; % 
    VertID = GetNRing(AdjMatrix, vi, numOfRings);    
    % Second, compute triangle n-ring out of vertex n-ring
    TriID = TriRing(VertID, Triangles);
    
    % Get all unique vertex IDs within the triangle n-ring
    VertID = unique(Triangles(TriID,:));
    VertID = VertID(find(VertID ~= vi));
    % Get coordinates of the vertices with n-ring patch
    XYZ = Vertices(VertID, :);
    % Add interest point coordinates on top    
    XYZ = [Vertices(vi, :); XYZ];
    
    numOfTri = size(TriID, 1);
	% Cartesian coordinates of triangle centroids
    XYZCentroid = zeros(numOfTri, 3);
    for i = 1 : numOfTri        
        TriangleVertexIDs = Triangles(TriID(i), :)';
        XYZCentroid(i, :) = Centroid(Vertices(TriangleVertexIDs, :));
    end % for
    
    LocalPatch.XYZ = XYZ;  
    LocalPatch.XYZCentroid = XYZCentroid;
    LocalPatch.VertID = [vi VertID'];    
    LocalPatch.TriID = TriID';
    Frames = [1 2 3 4];    
end % function