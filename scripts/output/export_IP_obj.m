function [] = export_IP_obj(export_dir, IP_mesh, J, T, S, C, opacity, n_f)

vertices = IP_mesh.vertices;
triangles = IP_mesh.triangles;
n_v = size(vertices, 1);
n_t = size(triangles, 1);

max_IP_num = max_num_repetitions(J);
V = zeros(n_v * max_IP_num, 3);

TRI = zeros(n_t * max_IP_num, 3);
for i = 1 : max_IP_num
    TRI((i-1)*n_t + 1 : i*n_t, :) = triangles + repmat((i-1)*n_v, n_t, 3);
end % for

% Export all frames
for f_i = 1 : n_f
    % J is a vector of frame ids with interest points
    I = find(J == f_i); 
    k = size(I, 1);
    
    for j = 1 : k
        % Translate, Scale, Color
        i = I(j); % 
        
        v = vertices .* S(i);
        v = v + repmat(T(i, :), n_v, 1);        
        V((j-1)*n_v + 1 : j * n_v, :) = v;
    end % for
    
    k = k + 1;
    for j = k : max_IP_num
        % Collapse rest
        V((j-1)*n_v + 1 : j * n_v, :) = zeros(n_v, 3);
    end % for      
    
    %exportOBJ(fileName, V, TRI);
    export_obj_mtl(export_dir, f_i, V, TRI, I, C, opacity, n_v, n_t);
end % for

end % function

