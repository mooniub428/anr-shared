function [] = export_obj(objFileName, mtlFileName, V, TRI, n_v, n_t)

[fid, msg] = fopen(objFileName, 'wt');
if (fid == -1) error(msg); end % if

fprintf(fid, ['mtllib ' mtlFileName '\n\n']);

k = size(V, 1) / n_v; % number of groups in OBJ file
for i = 1 : k
    vertices = V((i-1)*n_v + 1 : i*n_v, :);
    triangles = TRI((i-1)*n_t + 1 : i*n_t, :);
    export_obj_group(fid, i, vertices, triangles);
end % for

fclose(fid);

end % function

