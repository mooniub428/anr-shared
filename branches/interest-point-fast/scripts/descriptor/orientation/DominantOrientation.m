% Compute a new basis which is aligned as the dominant gradient direction
%
function [ePrime] = DominantOrientation(p, SurfPatchFlat, V, DeformScalar, Adj)

% Compute gradients for each point within the patch
G = GradientSet(DeformScalar, SurfPatchFlat, V, Adj);

% Compute histogram
H = HistogramOfGradient(p, SurfPatchFlat.XYZ, G);

% Estimate the peak of the histogram i.e. the dominant gradients direction 
[ePrime] = FindPeak(H);


end % function

