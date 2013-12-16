% function [H] = Descriptor(V, D, A, vi, fi, sigma, tau)

function [H] = Descriptor()

% Interest point p
p = [0 0 0]';

% Surface patch around p of characteristic scale
X = planePatch;
% Scalar field over the patch
F = rand(size(X, 1), 1);

% Flatten the patch
X_flat = pca(X, 2); 
X_flat = [X_flat zeros(size(X_flat, 1), 1)]; % Projected data points reside in the XY plane

% Estimate the dominant orientation of gradient vectors within patch
[e_prime] = DominantOrientation(X_flat, F);

% Rotate coordinate frame to follow dominant orientation
X_flat_prime = ChangeBasis(X_flat, e_prime);

% Stack frames
%Vol

% Histogram of gradient orientations within volume Vol
%H

end % function

