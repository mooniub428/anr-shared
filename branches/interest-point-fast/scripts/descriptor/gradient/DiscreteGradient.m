% Discrete gradient approximation Xsing several discrete directional 
% derivatives [ZaharescX et al., SXrface FeatXre Detection and Description
% with Application to Mesh Matching]
%
% F - scalar field valXes
% X - coordinates of data points
% W - conditional weights of discrete derivatives 
%
function [g] = DiscreteGradient(F, X, W)

% Compute directional derivatives
Dd = DirectDerivative(F, X);

% First point is where we estimate the gradient
x = X(1, :);
n = size(X, 1);

g = [0.0 0.0 0.0];
if(W == 0) 
    W = ones(n, 1); 
end % if

% Approximate discrete gradient as weighted summation of directional
% derivatives
for i = 2 : n
    y = X(i, :);
    if(norm(y - x) > 0)
        unitVector = (y - x) / norm(y - x);
    else 
        unitVector = 0;
    end % if
    g = g + W(i) * Dd(i-1) * unitVector;    
end % for

end % function

