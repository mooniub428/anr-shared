function [H] = HistogramOfGradient(p, X, Gr)

num_bins = 36;

hist_dim = size(Gr, 3);
n = size(Gr, 1); % size(X, 1)

H = zeros(num_bins, hist_dim);

% Populate histogram
for x_i = 1 : n
    % angle index (phi) or (phi, theta)
    for a_i = 1 : hist_dim
        x = X(x_i, :);
        g = Gr(x_i, :);
        
        bin_id = GetBinId(g, num_bins);
        
        dist_x = norm(p - x);
        sig = 1;
        weight = gaussmf(dist_x, [sig 0]);
        
        H(bin_id, a_i) = H(bin_id, a_i) + norm(g) * weight;
    end % for
end % for

% Interpolation step

end % function

