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