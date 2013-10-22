% Write out files

function [ output_args ] = result( input_args )

c = [122 122 255];
load('Data/sphere_dat.mat');
orig_tri = triangles;
vert_s = vert_s / 80;


for i = 2 : n_f
    F = f_pts(:, i);
    % Get feature tri ids
    features = find(F);  
    
    N = D_eigen(features,:,i) - 1.0;
    N = sqrt( diag(N * (N')) );
    feat_ids = find(N > 1.0);
    
    % Paint all triangles in grey (Initial face color list)
    face_c_list = ones(n_t, 3) * 150;
    % Paint feature triangles in red
    face_c_list( find(F), :) = repmat(c, numel(find(F)), 1);
    %face_c_list = [face_c_list; repmat(c, numel(find(F)) * size(tri_s, 1), 1)];
    
    %
    tri_id_shift = n_v;
    orig_verts = reshape(V(:,:, i), n_v, 3);
    triangles = orig_tri;
    frame_verts = reshape(V(:,:, i), n_v, 3);
    
    color_coef = zeros(size(features,1), 1);    
    %for j = 1 : size(features,1)
    for j = 1 : size(feat_ids, 1);
        t = features(feat_ids(j));
        
        color_coef(j) = norm(reshape(D_eigen(t,:,n_f), n_dim, 1) - 1.0);        
        %new_f_c_list = zeros(tri_s, 3);
        new_f_c_list = repmat(c, size(tri_s, 1), 1);
        face_c_list = [face_c_list; new_f_c_list];
        %face_c_list = [face_c_list; repmat(c*color_coef(j), size(tri_s, 1), 1)];
        
        barycenter = GetBarycenter(orig_verts, orig_tri, t);
        frame_verts =[frame_verts; (vert_s + repmat(barycenter,size(vert_s,1),1))];
        triangles = [triangles; (tri_s + repmat(tri_id_shift, size(tri_s,1), 3))];
        tri_id_shift = tri_id_shift + size(vert_s, 1);
    end % for
    displacement = [0.5 0.0 0.0];
    frame_verts = repmat(displacement, size(frame_verts, 1), 1) + frame_verts;
    exportPLY( ['Result/' data_name '/' data_name int2str(i) '.ply'], frame_verts, 0, triangles, face_c_list);
    %exportPLY( ['Result/' data_name '/' data_name int2str(i) '.ply'], V(:,:, i), 0, triangles, face_c_list);
    %
end % for

end % function

