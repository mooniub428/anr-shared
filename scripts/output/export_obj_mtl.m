function [] = export_obj_mtl(export_dir, f_i, V, TRI, C, opacity, n_v, n_t)

% Write material file
mtlFileName = ['ip-mtllib-' int2str(f_i) '.mtl'];
mtlFilePath = [export_dir mtlFileName];
[fid, msg] = fopen(mtlFilePath, 'wt');
fprintf(fid, '# Material file\n');
for i = 1 : size(C, 1)    
    fprintf(fid, ['newmtl ip_' int2str(i) '\n']);
	fprintf(fid, 'Ns 10.0000\n');
	fprintf(fid, 'Ni 1.5000\n');
	fprintf(fid, 'd 0.1500\n');
	fprintf(fid, 'Tr 0.8500\n');
	fprintf(fid, 'Tf 0.5000 0.5000 0.5000\n');
	fprintf(fid, 'illum 2\n');
    color = int2str(C(i, :));
	fprintf(fid, ['Ka ' color '\n']);
	fprintf(fid, ['Kd ' color '\n']);
	fprintf(fid, 'Ks 0.0000 0.0000 0.0000\n');
	fprintf(fid, 'Ke 0.0000 0.0000 0.0000\n');
    fprintf(fid, '\n');
end % for
fclose(fid);

% Export OBJ with separate IP objects and different materials
objFileName = [export_dir 'ip-frame-' int2str(f_i) '.obj'];
export_obj(objFileName, mtlFileName, V, TRI, n_v, n_t);

end % function

