% Change coordinates from an old basis E to a new basis E_prime
%
function [X_prime] = ChangeBasis(X, e_prime)

angle = RotAngle(e_prime);

% Get rotation matrix
R = RotMatrixZ(angle);

X_ = X(:, 1 : 3);
% Transform coordinates
X_prime = R * X_';

X_prime = X_prime';
X_prime(:, 4) = X(:, 4);

end % function

