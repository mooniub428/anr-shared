% Generates a maxscript for creation of spline which out of set of sectors
function [] = Vectors2MaxscriptSplines(VectorsStart, VectorsEnd)

% Create output maxscript file
fileName = 'generate_splines.ms';
[fid, Msg] = fopen(fileName, 'wt');
if (fid == -1)
    error(Msg);
end % if

% Define spline shape
fprintf(fid, 'ss = SplineShape pos:[0,0,0]\n');

% Write next spline
numOfVectors = size(VectorsStart, 1);
for i = 1 : numOfVectors
    fprintf(fid, 'addNewSpline SplineSegment\n');
    fprintf(fid, 'addKnot SplineSegment %d #corner #line ', i);
    
    fprintf(fid, '[');
    for k = 1 : 2
        fprintf(fid, '%f,', VectorsEnd(i, k));
    end % FOR
    fprintf(fid, '%f]\n', VectorsEnd(i, k + 1));
    
    fprintf(fid, 'addKnot SplineSegment %d #corner #line ', i);
    fprintf(fid, '[');
    for k = 1 : 2
        fprintf(fid, '%f,', VectorsEnd(i, k));
    end % FOR
    fprintf(fid, '%f]\n', VectorsEnd(i, k + 1));
end % for

fprintf(fid, 'updateShape ss\n');

% Close the file
fclose(fid);

end % function

