% Discrete gradient approximation using several discrete directional 
% derivatives [Zaharescu et al., Surface Feature Detection and Description
% with Application to Mesh Matching]
%
function [g] = DiscreteGradient(F, U, W)

Dd = DirectDerivative(F, U);

x = U(1, :);
n = size(U, 1) - 1;

g = [0.0 0.0 0.0];
if(W == 0) W = ones(n + 1); end % if

for i = 1 : n
    y = U(i, :);
    g = g + W(i + 1) * Dd(i) * (y - x);
end % for

g = g';

end % function

