function [G] = planePatch()

k = 1;
X = -k : k;
Y = -k : k;

d = 1;
[a b c] = plane([1 0 0]',[0 2 0]', [0 0 1]', d);

G = zeros((k * 2 + 1)^2, 3);
for i = 1 : (2 * k + 1)
    for j = 1 : (2 * k + 1)
        x = X(i);
        y = Y(j);
        [z] = z4planeXY(a, b, c, d, x, y);
        G((i - 1) * (2 * k + 1) + j, 1) = x;
        G((i - 1) * (2 * k + 1) + j, 2) = y;
        G((i - 1) * (2 * k + 1) + j, 3) = z;
    end % for
end % for

end % function

