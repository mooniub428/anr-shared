% function [H] = Descriptor(V, D, A, vi, fi, sigma, tau)

function [H] = Descriptor()

% Interest point p
p = [0 0 0]';

% Surface patch around p of characteristic scale
G = planePatch;
% Scalar field over the patch
F = rand(size(G, 1), 1);

% Flatten the patch
Gflat = pca(G, 2); % Projected data points reside in the XY plane

% Original basis XYZ i.e. flattened
E_orig = eye(3);

% New basis obtained by rotating original basis to align with dominant
% orientation
[E_prime] = DominantOrientBasis(E_orig, Gflat, F);

% Changes basis from original to the new dominant oriented 
Gflat_prime = ChangeBasis(E_orig, E_prime, Gflat);

% Stack frames
%Vol

% Histogram of gradient orientations within volume Vol
%H

end % function
