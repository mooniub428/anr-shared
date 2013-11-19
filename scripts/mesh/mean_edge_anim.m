function [mean_edge_anim] = mean_edge_anim(V, A)
disp(':: Compute mean edge');
n_f = size(V, 3);
n_v = size(V, 1);

mean_edge_anim_array = zeros(n_f, 1);

parfor f_i = 1 : n_f
    mean_edge_anim_array(f_i) = mean_edge_frame(reshape(V(:,:, f_i), n_v, 3), A);
end % for

mean_edge_anim = mean(mean_edge_anim_array);

end % function

