% Change coordinates from an old basis E to a new basis E_prime
%
function [X_prime] = ChangeBasis(X, e_prime)

angle = RotAngle(e_prime);

% Get rotation matrix
R = RotMatrixZ(angle);

% Transform coordinates
X_prime = R * X;

end % function

