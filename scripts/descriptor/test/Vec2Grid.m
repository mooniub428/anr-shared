function [px, py] = Vec2Grid(P)

n = sqrt(size(P, 1));

px = zeros(n);
py = zeros(n);

X = P(:, 1);
Y = P(:, 2);

py = reshape(X, n, n);
px = reshape(Y, n, n);
px = px';

end % function

