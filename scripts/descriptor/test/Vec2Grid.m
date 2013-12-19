function [px, py] = Vec2Grid(P)

n = sqrt(size(P, 1));

px = zeros(n);
py = zeros(n);

X = P(:, 1);
Y = P(:, 2);

px = reshape(X, n, n);
py = reshape(Y, n, n);

end % function

