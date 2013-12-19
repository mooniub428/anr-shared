% Convert grid representation of the data points
% to vector representation
%
function [V] = Grid2Vec(X, Y, Z)

n = size(X, 1);
V = zeros(n ^ 2, 3);

% Populate V
for i = 1 : n
    for j = 1 : n
        V((i - 1) * n + j, :) = [X(i, j) Y(i, j) Z(i, j)];
    end % for
end % for

end % function

