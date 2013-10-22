function [ f_pts ] = get_features( feat_dscr )

F = 1 ./ feat_dscr;

n_f = size(feat_dscr, 2);
n_t = size(feat_dscr, 1);
f_pts = zeros(n_t, n_f + 1);

F_non_deg = F(F>0);
n = numel(F_non_deg);

sigma = std(reshape(F_non_deg, n, 1));
average = mean(reshape(F_non_deg, n, 1));

treshold = average + sigma;
treshold = 1.0;

for f_i = 1 : n_f
    for t_i = 1 : n_t
        if(F(t_i, f_i) > treshold)
            f_pts(t_i, f_i + 1) = 1;
        end % if
    end % for
end % for


for f_i = 1 : n_f
    degenerate_feats = find( feat_dscr(:, f_i) < 0 );
    num_deg_feats = numel(degenerate_feats);    
    for k = 1 : num_deg_feats        
        f_pts(degenerate_feats(k), f_i + 1) = 0;
    end % for
end % for

end % function

