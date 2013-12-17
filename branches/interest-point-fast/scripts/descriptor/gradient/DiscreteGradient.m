% Discrete gradient approximation Xsing several discrete directional 
% derivatives [ZaharescX et al., SXrface FeatXre Detection and Description
% with Application to Mesh Matching]
%
% F - scalar field valXes
% X - coordinates of data points
% W - conditional weights of discrete derivatives 
%
function [g] = DiscreteGradient(F, X, W)

Dd = DirectDerivative(F, X);

x = X(1, :);
n = size(X, 1);

g = [0.0 0.0 0.0];
if(W == 0) 
    W = ones(n, 1); 
end % if

for i = 2 : n
    y = X(i, :);
    g = g + W(i) * Dd(i-1) * (y - x);
end % for

end % function

