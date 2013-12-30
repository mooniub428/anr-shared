% Directional derivatives of a scalar function F along 
% given vectors U(2:,:) at a given point x = U(1, :)
%
function [Dd] = DirectDerivative(F, U)

x = U(1, :);
Fx = F(1);

n = size(U, 1);
Dd = zeros(n - 1, 1);

for i = 2 : n
    y = U(i, :);
    Fy = F(i);
    if(norm(y - x) > 0)
        Dd(i - 1) = (Fy - Fx) / norm(y - x);
    else
        Dd(i - 1) = 0;
    end % if
end % for

end % function

