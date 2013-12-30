function [SurfPatch, Frames] = GetCharacteristicScale(V, Adj, vi, fi, sigma, tau)

n = size(V, 1);
[XYZ, ~] = RingNeighb(vi, V, zeros(n, 1), Adj);
XYZ = [V(vi,:); XYZ];
SurfPatch.XYZ = XYZ;
ID = find(Adj(vi, :));
SurfPatch.ID = [vi ID];
Frames = fi;

end % function

