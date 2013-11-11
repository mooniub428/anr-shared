function [] = export_obj(objFileName, mtlFileName, V, TRI, I, n_v, n_t)

[fid, msg] = fopen(objFileName, 'wt');
if (fid == -1) error(msg); end % if

fprintf(fid, ['mtllib ' mtlFileName '\n\n']);

IP_num = size(V, 1) / n_v;

for k = 1 : IP_num
    vertices = V((k - 1)*n_v + 1 : k * n_v, :);
    triangles = TRI((k - 1)*n_t + 1 : k * n_t, :);    
    export_obj_group(fid, k, I, vertices, triangles);
end % for

fclose(fid);

end % function

