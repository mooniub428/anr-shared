function [X, A] = planePatch()

k = 1;
U = -k : k;
W = -k : k;

d = 1;
[a b c] = plane([1 0 0]',[0 2 0]', [0 0 1]', d);

X = zeros((k * 2 + 1)^2, 3);

for i = 1 : (2 * k + 1)
    for j = 1 : (2 * k + 1)
        x = U(i);
        y = W(j);
        [z] = z4planeXY(a, b, c, d, x, y);
        X((i - 1) * (2 * k + 1) + j, 1) = x;
        X((i - 1) * (2 * k + 1) + j, 2) = y;
        X((i - 1) * (2 * k + 1) + j, 3) = z;                       
    end % for
end % for

% Generate adjacency matrix
A = zeros( (k * 2 + 1)^2 );
i = 5;
A(i, :) = ones(1, (k * 2 + 1)^2);
A(:, i) = ones((k * 2 + 1)^2, 1);
A(i, i) = 0;

end % function

