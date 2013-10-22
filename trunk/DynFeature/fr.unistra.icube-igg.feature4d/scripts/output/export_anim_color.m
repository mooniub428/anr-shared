function [ ] = export_anim_color( feature_response, featpts, vertices_with_spheres, n_spheres, n_sphere_vertices, param )

% String constants
export_dir = ['../../fr.unistra.icube-igg.debug/' param.data_name '/'];
% Create export directory if it does not exist
enforce_existence(export_dir);

if(param.do_scale_norm)
    export_dir = [export_dir '/norm/'];
else
    export_dir = [export_dir '/notnorm/'];
end % if

enforce_existence(export_dir);

n = size(feature_response, 1); % num of vertices in original model
n_with_spheres = size(vertices_with_spheres, 1); % num of vertices in augmented model
n_f = size(feature_response, 2);



% Compute color
feat_strength = zeros(size(featpts, 1), 1);

for k = 1 : size(featpts, 1)
    feat_v = featpts(k,1);
    feat_f = featpts(k, 2);
    feat_strength(k) = feature_response(feat_v, feat_f);
end % for

color_per_feature = produce_color(feat_strength) / 255;

C = [];
for fi = 2 : n_f
    scalars = feature_response(:, fi);
    c = produce_color(scalars) / 255;
    C=[C; c]; 
    
    c_spheres = [];
%     % ERROR
%     feat_id = find(featpts(:,2)==fi);
%     num_feat = numel(feat_id);
%     for j = 1 : num_feat
%         c_spheres = [c_spheres; repmat(color_per_feature(feat_id(j),:), n_sphere_vertices, 1)]; 
%     end % for
%     num_rest = n_spheres - num_feat;
    num_rest = n_spheres;
    %c_spheres = [c_spheres; zeros(num_rest * n_sphere_vertices, 3)];
    c_spheres = [c_spheres; ones(num_rest * n_sphere_vertices, 3)];
    
    C = [C; c_spheres];
end % for

save([export_dir 'colors.txt'], 'C', '-ascii');

save([export_dir 'feature_response.mat'], 'feature_response');

end % function

