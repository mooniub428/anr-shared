% Compute 2d radial histogram descriptor based on curface deformation
% principal axes
function [] = DescriptorPrincipalAxes(Vertices, Triangles, E, Adj, vi, fi, sigma, tau)
    % Get local triangle patch around the interest point
    [LocalPatch, Frames] = GetTriPatch(Vertices, Triangles, Adj, vi, sigma, tau);
    
    % Flatten vertices within the patch
    XY = pca(LocalPatch.XYZ, 2);
    LocalPatchFlat = LocalPatch;
    LocalPatchFlat.XYZ = [XY zeros(size(XY, 1), 1)];     
    
    % Compute principal directions with respect to their barycentric
    % coordinates
	% LocalPatchFlat.PrincipalAxes
    LocalPatchFlat = GetPrincipalAxesFromBarycentric(LocalPatchFlat, Triangles, E, fi);
    %interpolate2(PrincipalAxes);
end % function

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
	end % for
end % function

function [LocalPatch, Frames] = GetTriPatch(Vertices, Triangles, AdjMatrix, vi, sigma, tau)    
    % First, get vertex n-ring around interest point at characteristic scale
    numOfRings = 1; % 
    VertID = GetNRing(AdjMatrix, vi, numOfRings);    
    % Second, compute triangle n-ring out of vertex n-ring
    TriID = triRing(VertID, Triangles, AdjMatrix, vi);
    
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
        XYZCentriod(i, :) = Centroid(Vertices(TriangleVertexIDs, :));
    end % for
    
    LocalPatch.XYZ = XYZ;  
    LocalPatch.XYZCentroid = XYZCentroid;
    LocalPatch.VertID = [vi VertID'];    
    LocalPatch.TriID = TriID';
    Frames = [1 2 3 4];    
end % function


%%
function [triRing] = triRing(VertID, Triangles, AdjMatrix, vi)    
    triRing = [];
    numOfRingPoints = size(VertID, 1);
    for i = 1 : numOfRingPoints
        [ti, ~] = find(Triangles == VertID(i));
        triRing = [triRing; ti];
    end % for
    triRing = unique(triRing);
end % function

function [NRingPointIds] = GetNRing(AdjMatrix, vi, n)
    NRingPointIds = [];
    if(n == 1)
        NRingPointIds = GetOneRing(AdjMatrix, vi);
    else
        OneRingPointIds = GetOneRing(AdjMatrix, vi);
        numOfOneRingPoints = numel(OneRingPointIds);
        for i = 1 : numOfOneRingPoints
            nextVi = OneRingPointIds(i);
            NRingPointIds = [NRingPointIds; nextVi; GetNRing(AdjMatrix, nextVi, n - 1)];
        end % for
    end %if
    NRingPointIds = unique(NRingPointIds);
end % function

function [OneRingPointIds] = GetOneRing(AdjMatrix, vi)
    OneRingPointIds = find(AdjMatrix(:, vi));
end % function