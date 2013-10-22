function [ seed_feats ] = group_feats( feats, V, triangles, proximity )

n_v = size(V, 1);
n_t = size(feats, 1);
n_f = size(feats, 2);

seed_feats = zeros(n_t, n_f);

for f_i = 1 : n_f
    frame_feats = feats(:, f_i);
    embedding = reshape(V(:,:, f_i), n_v, 3);
    feat_idx = find(frame_feats);
    feat_embed = embedding(feat_idx, :);
    dist_mtr = pdist(feat_embed);
    
    feat_indicator = ones(size(frame_feats, 1), 1);
    
    if(numel(dist_mtr) > 0)
        Z = linkage(dist_mtr);
        c = cluster(Z,'cutoff', proximity);
        % Fetch a seed point from each cluster
        k = numel(unique(c));
        for j = 1 : k
            cluster_idx = find(c==j);
            seed_id = cluster_idx(1);
            seed_feats(feat_idx(seed_id), f_i) = 1;
        end % for
    end % if
    
end % for

end % function

