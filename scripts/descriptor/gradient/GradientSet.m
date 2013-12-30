% Compute gradient vector field with the Patch
% Patch = subset(PatchWithBorder)
% A - full adjacency matrix (full mesh)
% (local adjacency of the Patch and PatchWithBorder is a subset of full 
% adjacency matrix A)
% 4th column of Patch/PatchWithBorder contains indices of vertices included
% 
function [G] = GradientSet(DeformScalar, SurfPatchFlat, V, Adj)

numVert = size(SurfPatchFlat.XYZ, 1);
% Init gradient set
G = zeros(numVert, 3);

Pid = SurfPatchFlat.ID;
for i = 1 : numVert   
    pid = Pid(i);
    [Rn, Fn] = RingNeighb(pid, V, DeformScalar, Adj);
    G(i, :) = DiscreteGradient([DeformScalar(pid); Fn], [SurfPatchFlat.XYZ(i,:); Rn], 0);
end % for

end % function

