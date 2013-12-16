function [H] = HistogramOfGradient(V, Gr)

num_bins = 36;

hist_dim = size(Gr, 3);
n = size(Gr, 1);

H = zeros(n, hist_dim);

end % function

