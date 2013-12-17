% Estimate the peak of the histogram / the dominant gradients direction 
%
function [dominant_vector] = FindPeak(H)

num_bins = 36;
% Find bin id which contains maximal direction votes
[~, bin_id] = max(H);

bin_id

radial_width = (2 * pi) / num_bins;
angle = (bin_id - 0.5) * radial_width; 
R = RotMatrixZ(angle);
dominant_vector = [1.0 0.0 0.0];
dominant_vector = R * dominant_vector';

end % function

