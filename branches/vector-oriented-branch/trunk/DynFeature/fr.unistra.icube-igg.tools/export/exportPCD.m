function [] = exportPCD( filename, vertices, landmarkId )

% RGB color table available on the wen
% http://vela.astro.ulg.ac.be/Vela/Colors/rgb.html

% color in HEX
pointColorHex = '008B00'; % green4
landmarkColorHex = 'FF0000'; % red

% Color in DEC
pointColor = hex2dec(pointColorHex);
landmarkColor = hex2dec(landmarkColorHex);

% Open file
[fid, Msg] = fopen(filename, 'wt');
if ( fid == -1 )
    % something went wrong while opening the file
    error(Msg);
end % if

% Number of point samples
nV = size(vertices, 1);

% Write header
fprintf(fid, '# .PCD v.7 - Point Cloud Data file format\n');
fprintf(fid, 'VERSION .7\n');
fprintf(fid, 'FIELDS x y z rgb\n');
fprintf(fid, 'SIZE 4 4 4 4\n');
fprintf(fid, 'TYPE F F F F\n');
fprintf(fid, 'COUNT 1 1 1 1\n');
fprintf(fid, 'WIDTH %d\n', nV);
fprintf(fid, 'HEIGHT 1\n');
fprintf(fid, 'VIEWPOINT 0 0 0 1 0 0 0\n');
fprintf(fid, 'POINTS %d\n', nV);
fprintf(fid, 'DATA ascii\n');


% Write the data
for vi = 1 : nV   
    for i = 1 : 3
        fprintf(fid, '%f ', vertices(vi, i));
    end % for
	
	if ( vi == landmarkId )
		fprintf(fid, '%f ', landmarkColor);
	else
		fprintf(fid, '%f ', pointColor);
	end % if
	
    fprintf(fid, '\n');
end % for vertices

end % function