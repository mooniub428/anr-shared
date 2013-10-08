% Load tools
addpath('../../../fr.unistra.icube-igg.tools/obj');
addpath('../../../fr.unistra.icube-igg.tools/export');
addpath('../../../fr.unistra.icube-igg.tools/color');

% Load horse model
%[vertices_h, triangles_h] = read_wobj('horse-gallop-reference.obj');
n_t_h = size(triangles_h, 1);

% Load camel model
%[vertices_c, triangles_c] = read_wobj('camel-gallop-reference.obj');
n_t_c = size(triangles_c, 1);

% Load camel to horse triangle correspondences
ct2ht = cell(n_t_c, 1);
ct2ht = load_cor('horsecamel.cor', ct2ht);

% Compute colors per each vertex of the horse
rgb_c_v = xyz2rgb(vertices_c);
rgb_c = zeros(n_t_c, 3);
% Convert vertex color to triangles color
for i = 1 : n_t_c
    tri = triangles_c(i, :)';
    rgb_c(i, :) = floor(mean(rgb_c_v(tri, :)));
end % for

% For each vertex from target (camel) assign its color to corresponding vertex on
% the source (horse)
% Note: target to source is one-to-many 
rgb_h = zeros(n_t_h, 3);
for i = 1 : n_t_c
    cor_tri = cell2mat(ct2ht(i));
    n_cor = numel(cor_tri);
    for k = 1 : n_cor
        tri = cor_tri(k);
        rgb_h(tri, :) = rgb_c(i, :);
    end % for
end % for

% Export color mapping files (for MeshLab)
exportPLY('horse_map.ply', vertices_h, 0, triangles_h, rgb_h);
exportPLY('camel_map.ply', vertices_c, 0, triangles_c, rgb_c);

% Export OBJs with accompanying color text files (for 3ds Max)
exportOBJ('horse_map.obj', vertices_h, triangles_h);
rgb_h = rgb_h / 255;
save('horse_color.txt', 'rgb_h');
exportOBJ('camel_map.obj', vertices_c, triangles_c);
rgb_c = rgb_c / 255;
save('camel_color.txt', 'rgb_c');