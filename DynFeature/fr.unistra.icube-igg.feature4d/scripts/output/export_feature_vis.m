function [ vertices_with_spheres ] = export_feature_vis( D_, objseq, param, featpts )

% Feature object parameters
radius = 0.02 * max_diag_bbox(objseq.vertices);      % radius of features

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

basename = 'frame_';

% Estimate number of additional feature points needed
featpts_ = cell2mat(featpts);
num_featpts_ = 0;
for fi = 2 : objseq.n_f
    num_featps_per_frame = sum( featpts_(:, 2, :, :, :) == fi );
    if(num_featps_per_frame > num_featpts_)
        num_featpts_ = num_featps_per_frame;
    end % if
end % for

% Triangulation of the mesh
triangles = objseq.triangles;
triangles_orig = triangles;

% Load object to represent features
[sphere_vertices, sphere_triangles] = read_wobj('UnitSphere.obj');
% Scale
sphere_vertices = sphere_vertices * radius;


% Attach triangles of the spheres to the list of triangles of the mesh
vertices = reshape(objseq.V(:, :, 1), objseq.n_v, 3);
if(num_featpts_ > 0)    
    for i = 1 : num_featpts_
        triangles = [triangles; sphere_triangles + repmat(size(vertices, 1), size(sphere_triangles, 1), 3) + repmat((i-1)*size(sphere_vertices, 1), size(sphere_triangles, 1), 3)];        
    end % for        
end

% Iterate over all frames
for fi = 2 : objseq.n_f
    % Serial number of the frame
    id = int2str(fi);
    
    %if (fi < 10)
    %    id = ['0' id];
    %end % if
    
    % Filename of the exported frame
    filename = [export_dir basename id '.obj'];
    
    % Get vertices of the mesh in the current frame
    vertices = reshape(objseq.V(:, :, fi), objseq.n_v, 3);
    
    % Get features for the current frame (fi)   
    cur_featpts_id = find(featpts_(:,2,:,:,:) == fi); % indices in the featpts_ matrix
    cur_featpts_ = int16(featpts_(cur_featpts_id));    
    
    % Attach vertices of the spheres 
    if(numel(cur_featpts_) > 0)
        cur_featpts_num = numel(cur_featpts_);
        for k = 1 : cur_featpts_num
            feat_id = cur_featpts_(k); %cur_featpts_(k);
            % Translate sphere to location p
            p = vertices(feat_id, :);
            P = repmat(p, size(sphere_vertices, 1), 1);
            vertices = [vertices; P + sphere_vertices];
        end % for
    end%if
    num_rest = abs(numel(cur_featpts_) - num_featpts_);
    vertices = [vertices; zeros(num_rest * size(sphere_vertices,1), 3)];       
    
    % Export the mesh
    exportOBJ(filename, vertices, triangles);
end % for

vertices_with_spheres = vertices;

% Save feature points matrix in text file as well
featpts_mat = cell2mat(featpts);
save([export_dir 'featpts_.txt'], 'featpts_mat', '-ascii');

end % function

