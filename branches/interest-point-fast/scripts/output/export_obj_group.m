function [] = export_obj_group(fid, group_i, material, vertices, triangles)

% Object header
fprintf(fid, '#\n');
fprintf(fid, ['# object ' int2str(group_i) '\n']);
fprintf(fid, '#\n');

nV = size(vertices, 1);
[nF, numberOfPolygonVertices] = size(triangles);

% Write the Vertex list
for iV = 1 : nV
    fprintf(fid, 'v ');
    for i = 1 : 3
        fprintf(fid, '%f ', vertices(iV, i));
    end
    fprintf(fid, '\n');
end %for
fprintf(fid, '\n');

% Write group
fprintf(fid, ['g ip_' int2str(group_i) '\n']);

% Write material if appropriate
material_num = numel(material);
if(group_i <= material_num)
    fprintf(fid, ['usemtl ip_' int2str(group_i) '\n']);
end % if

% Write the Face list
for iF = 1:nF
    fprintf(fid, 'f ');
    for i = 1:numberOfPolygonVertices
        fId = triangles(iF, i);
        fprintf(fid, '%d ', fId);
    end
    fprintf(fid,'\n');
end % for

fprintf(fid,'\n');

end % function

