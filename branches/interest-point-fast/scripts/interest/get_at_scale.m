function [scale, start_index, end_index] = get_at_scale(n_v, M, s_i, t_i, sigma, tau )

start_index = n_v * ((s_i - 1) * tau + t_i - 1) + 1;
end_index = n_v * ((s_i - 1) * tau + t_i);
scale = M(start_index : end_index, :);

end % function

