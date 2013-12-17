function [G] = GradientSet(p, F, Patch, PatchWithBorder, A)

n = size(Patch, 1);
G = zeros(n, 3);

for i = 1 : n
    [Rn, Fn] = RingNeighb(i, PatchWithBorder, F, A);
    G(i, :) = DiscreteGradient([F(i); Fn], [PatchWithBorder(i, 1:3); Rn], 0);
end % for

end % function

