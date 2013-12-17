% Compute a new basis which is aligned as the dominant gradient direction
%
function [e_prime] = DominantOrientation(p, Patch, PatchWithBorder, F, A)

% Initialize the basis with zeros
e_prime = zeros(3, 1);

% Compute gradients
G = GradientSet(p, F, Patch, PatchWithBorder, A);

% Compute histogram
H = HistogramOfGradient(p, Patch, G);

% Estimate the peak of the histogram i.e. the dominant gradients direction 
% [phi_dominant, ~] = FindPeak(H);


end % function

