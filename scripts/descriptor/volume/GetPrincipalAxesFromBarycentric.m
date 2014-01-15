% Compute principal strain axes in a flattened patch out of their
% barycentric coordinates in non-flattened patch
%
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