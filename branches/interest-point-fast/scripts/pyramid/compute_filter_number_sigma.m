function [n2] = compute_filter_number_sigma(n1, d1, d2)

n2 = n1 * (d1 / d2)^2;

end % function

