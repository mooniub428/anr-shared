function [  ] = export_anim_color( feature_response, vertices_with_spheres )

% String constants
export_dir = '../../fr.unistra.icube-igg.debug/featpts_vis/';

n = size(feature_response, 1); % num of vertices in original model
n_with_spheres = size(vertices_with_spheres, 1); % num of vertices in augmented model
n_f = size(feature_response, 2);

% Compute color
C = zeros(n_with_spheres, 3);
for fi = 2 : n_f
    scalars = feature_response(:, fi);
    scalars = [scalars; max(scalars) * ones(n_with_spheres - n, 1)];
    c = produce_color(scalars) / 255;
    C=[C; c]; 
end % for

save([export_dir 'colors.txt'], 'C', '-ascii');

end % function

