% Change coordinates from an old basis E to a new basis E_prime
%
function [X_prime] = ChangeBasis(E, E_prime, X)

% Change of basis matrix
C = E_prime'; 

% Transform coordinates
X_prime = C * X;

end % function

