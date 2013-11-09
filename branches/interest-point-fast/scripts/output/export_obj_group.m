function [] = export_obj_group(fid, i, vertices, triangles)

% Object header
fprintf(fid, '#\n');
fprintf(fid, ['# object ' int2str(i) '\n']);
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
fprintf(fid, ['g ip_' int2str(i) '\n']);

% Write material
fprintf(fid, ['usemtl ip_' int2str(i) '\n']);

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

