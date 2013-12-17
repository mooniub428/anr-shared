% Compute a new basis which is aligned as the dominant gradient direction
%
function [e_prime] = DominantOrientation(p, Patch, PatchWithBorder, F, A)

% Compute gradients for each point within the patch
G = GradientSet(p, F, Patch, PatchWithBorder, A);

% Compute histogram
H = HistogramOfGradient(p, Patch, G);

% Estimate the peak of the histogram i.e. the dominant gradients direction 
[e_prime] = FindPeak(H);


end % function

