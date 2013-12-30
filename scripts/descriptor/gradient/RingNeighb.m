% Get first ring neighbours of point p, given adjacency matrix A and a surface
% patch
%
function [Rn, Fn] = RingNeighb(pid, PatchWithBorder, F, A)

Nb = find(A(:, pid));
n = size(Nb, 1);
Rn = zeros(n, 3);
Fn = zeros(n, 1);

for i = 1 : n
    nextId = Nb(i);
    nextPoint = PatchWithBorder(nextId);
    Rn(i, :) = nextPoint;
    Fn(i) = F(nextId);
end % for

end % function

