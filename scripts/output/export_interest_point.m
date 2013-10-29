function [IP_union] = export_interest_point(objseq, param, IP, sigma, tau)
IP_union = zeros(objseq.n_v, objseq.n_f);
tau = tau - 1;
sigma = sigma - 1;

for t_i = 2 : tau
    for s_i = 2 : sigma
        from_id = (s_i - 1) * tau * objseq.n_v + 1 + (t_i - 1) * objseq.n_v;
        to_id = (s_i - 1) * tau * objseq.n_v + t_i * objseq.n_v;
        IP_at_scale = IP(from_id : to_id, :);
        IP_union = IP_union | IP_at_scale;
    end % for
end % for

IP = IP_union;

% Feature object parameters
radius = 0.02 * max_diag_bbox(objseq.vertices);      % radius of features

% String constants
enforce_existence('../../fr.unistra.icube-igg.debug/');
export_dir = ['../../fr.unistra.icube-igg.debug/' param.data_name '/'];
% Create export directory if it does not exist
enforce_existence(export_dir);

if(param.do_scale_norm)
    export_dir = [export_dir 'norm/'];
else
    export_dir = [export_dir 'notnorm/'];
end % if

enforce_existence(export_dir);

basename = 'frame_';

% Estimate number of additional feature points needed
num_IP = max(sum(IP, 1));

% Triangulation of the mesh
triangles = objseq.triangles;
triangles_orig = triangles;

% Load object to represent features
[sphere_vertices, sphere_triangles] = read_wobj('UnitSphere.obj');
n_sphere_vertices = size(sphere_vertices, 1);
% Scale
sphere_vertices = sphere_vertices * radius;


% Attach triangles of the spheres to the list of triangles of the mesh
vertices = reshape(objseq.V(:, :, 1), objseq.n_v, 3);
if(num_IP > 0)    
    for i = 1 : num_IP
        triangles = [triangles; sphere_triangles + repmat(size(vertices, 1), size(sphere_triangles, 1), 3) + repmat((i-1)*size(sphere_vertices, 1), size(sphere_triangles, 1), 3)];        
    end % for        
end

% Iterate over all frames
for fi = 2 : objseq.n_f
    % Serial number of the frame
    id = int2str(fi);
          
    % Filename of the exported frame
    filename = [export_dir basename id '.obj'];
    
    % Get vertices of the mesh in the current frame
    vertices = reshape(objseq.V(:, :, fi), objseq.n_v, 3);
    
    % Get features for the current frame (fi)   
    cur_IPid = find(IP(:,fi) == 1);      
        
    % Attach vertices of the spheres 
    cur_IPnum = numel(cur_IPid);
    if(cur_IPnum > 0)        
        for k = 1 : cur_IPnum
            feat_id = cur_IPid(k); 
            % Translate sphere to location p
            p = vertices(feat_id, :);
            P = repmat(p, size(sphere_vertices, 1), 1);
            vertices = [vertices; P + sphere_vertices];
        end % for
    end%if
    
    % 
    num_rest = abs(numel(cur_IPid) - num_IP);    
    
    vertices = [vertices; zeros(num_rest * size(sphere_vertices,1), 3)];       
    
    % Export the mesh
    exportOBJ(filename, vertices, triangles);
end % for

frames_with_IP = [(1 : size(IP, 2))' sum(IP)'];
frames_with_IP = double(frames_with_IP);
% Save feature points matrix in text file as well
save([export_dir 'IP.txt'], 'frames_with_IP', '-ascii');

end % function

