% Compute gradient vector field with the Patch
% Patch = subset(PatchWithBorder)
% A - full adjacency matrix (full mesh)
% (local adjacency of the Patch and PatchWithBorder is a subset of full 
% adjacency matrix A)
% 4th column of Patch/PatchWithBorder contains indices of vertices included
% 
function [G] = GradientSet(F, Patch, PatchWithBorder, A)

n = size(Patch, 1);
G = zeros(n, 3);

Pid = Patch(:, 4);
for i = 1 : n    
    pid = Pid(i);
    [Rn, Fn] = RingNeighb(pid, PatchWithBorder, F, A);
    G(i, :) = DiscreteGradient([F(pid); Fn], [Patch(i,1:3); Rn], 0);
end % for

end % function

