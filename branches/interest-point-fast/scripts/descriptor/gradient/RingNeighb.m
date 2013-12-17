% Get first ring neighbours of point p, adjacency matrix A, given a surface
% patch
%
function [Rn, Fn] = RingNeighb(pid, PatchWithBorder, F, A)

Id = PatchWithBorder(:, 4);

Nb = find(A(:, pid));
n = size(Nb, 1);
Rn = zeros(n, 3);
Fn = zeros(n, 1);

for i = 1 : n
    nextId = Nb(i)
    nextPoint = PatchWithBorder(find(Id == nextId), 1 : 3);
    Rn(i, :) = nextPoint;
    Fn(i) = F(find(Id == nextId));
end % for

end % function

