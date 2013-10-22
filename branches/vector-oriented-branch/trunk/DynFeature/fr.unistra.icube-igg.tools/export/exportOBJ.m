% Author:   Vasyl Mykhalchuk 
% Date:     30/04/2012 
% vertexList - matrix form
% faceList - matrix form
function [] = exportOBJ( filePath, vertexList, faceList)

format = 'ascii';
%
% Create file
%
[fid, Msg] = fopen(filePath, 'wt');
if ( fid == -1 )
    % something went wrong while opening the file
    error(Msg);
end%if

% ------------------------------------------------------------------------
nV = size(vertexList, 1);

[nF, numberOfPolygonVertices] = size(faceList);
% ------------------------------------------------------------------------

%-------------------------------------------------------------------------
%
% Write the Vertex list
%
for iV = 1 : nV
    fprintf(fid, 'v ');
    for i = 1 : 3
        fprintf(fid, '%f ', vertexList(iV, i));
    end
    fprintf(fid, '\n');
end%for loop vertexList
% ------------------------------------------------------------------------

%-------------------------------------------------------------------------
%
% Write the Face list
% 
for iF = 1:nF
    fprintf(fid, 'f ');
    for i = 1:numberOfPolygonVertices
        fId = faceList(iF, i);
        fprintf(fid, '%d ', fId);
    end
    fprintf(fid,'\n');
end%for loop faceList
%-------------------------------------------------------------------------

fclose(fid);

end%function exportPLY

