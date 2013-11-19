function [n2] = compute_filter_number(n1, sampling_rate1, sampling_rate2)

n2 = sqrt(n1) * (sampling_rate2 / sampling_rate1);

end % function

