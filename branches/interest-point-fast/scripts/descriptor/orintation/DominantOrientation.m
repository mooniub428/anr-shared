% Compute a new basis which is aligned as the dominant gradient direction
%
function [E_prime] = DominantOrientation(E_orig, V, F)

% Initialize the basis with zeros
E_prime = zeros(3);

% Compute gradients
Gr = DiscreteGradient(F, V, 0);

% Compute histogram
H = HistogramOfGradient(V, Gr);

% Estimate the peak of the histogram i.e. the dominant gradients direction 
phi_dominant = FindPeak(H);

% Rotate

end % function

