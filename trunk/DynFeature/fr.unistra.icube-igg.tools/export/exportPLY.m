% 
% Vasyl Mykhalchuk 
%
% Export mesh to PLY polygon file format (pretty simple and support vertex
% coloring)
% 
% For more info about ply format:
% http://paulbourke.net/dataformats/ply/
% http://www.mathworks.com/matlabcentral/fx_files/5459/1/content/ply.htm
% =========================================================================
% Polgyon file format consists of main three sections:
% a. Header
% b. Vertex list
% c. Face list
% =========================================================================
%
% NOTE: Current version does not support normals.
% NOTE2: Current version does support only for uniform meshes (uniform
% faces)
%
% INPUT:
% filePath - path to the exported PLY file (full or relative)

% vertexList - list of vertices in the mesh in the format of matrix N by 3,
%           where N is a total number of vertices in the mesh

% vertexColorList - list of rgb colors for each vertex, N by 3 matrix
% faceList - list of faces in a matrix format F by M, where F - number of faces
%               in the mesh, M - number of vertices in one face plus one
%               for instance quadrilateral face: 4 v1_index v2_index v3_index v4_index
%
%  Example of test data is below.
%

function [] = exportPLY( filePath, vertexList, vertexColorList, faceList, faceColorList)
%function [] = exportPLY( )


% Uncomment this block for small cube test
%{
filePath = 'test_vasyl.ply';

vertexList=[1.000000, 1.000000, -1.000000; 1.000000, -1.000000, -1.000000;
    -1.000000, -1.000000, -1.000000;-1.000000, 1.000000, -1.000000;
    1.000000, 0.999999, 1.000000;-1.000000, 1.000000, 1.000000;
    -1.000000, -1.000000, 1.000000;0.999999, -1.000001, 1.000000;
    1.000000, 1.000000, -1.000000;1.000000, 0.999999, 1.000000;
    0.999999, -1.000001, 1.000000;1.000000, -1.000000, -1.000000;
    1.000000, -1.000000, -1.000000;0.999999, -1.000001, 1.000000;
    -1.000000, -1.000000, 1.000000;-1.000000, -1.000000, -1.000000;
    -1.000000, -1.000000, -1.000000;-1.000000, -1.000000, 1.000000;
    -1.000000, 1.000000, 1.000000;-1.000000, 1.000000, -1.000000;
    1.000000, 0.999999, 1.000000;1.000000, 1.000000, -1.000000;
    -1.000000, 1.000000, -1.000000;-1.000000, 1.000000, 1.000000];

vertexColorList = [255, 255, 255; 255, 255, 255;
    255, 255, 255; 255, 255, 255;
    255, 255, 255; 255, 255, 255;
    255, 255, 255; 0, 255, 210;
    255, 255, 255;255, 255, 255;
    0, 255, 210;255, 255, 255;
    255, 255, 255;0, 255, 210;
    255, 255, 255;255, 255, 255;
    255, 255, 255;255, 255, 255;
    255, 255, 255;255, 255, 255;
    255, 255, 255;255, 255, 255;
    255, 255, 255;255, 255, 255];

faceList = [4,0,1,2,3; 4,4,5,6,7; 4,8,9,10,11; 4,12,13,14,15; 4,16,17,18,19; 4,20,21,22,23];
%}
writeVertexColors = 1;
if (vertexColorList == 0)
    writeVertexColors = 0;
end % if
writeFaceColors = 1;
if (faceColorList == 0)
    writeFaceColors = 0;
end % if

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
[nV,dimT] = size(vertexList);
[nVC,dimT] = size(vertexColorList);

if( writeVertexColors && (nV ~= nVC) ) 
    error('Number of vertex list is different from vertexColorList');
end%if

[nF,dimT] = size(faceList);
% ------------------------------------------------------------------------

%-------------------------------------------------------------------------
%
% Write the Header
%
topHeaderStr = strcat('ply\nformat %s 1.0\ncomment created by PLY exporter. ',datestr(now, 'yy'));
topHeaderStr = strcat(topHeaderStr, ' lsiit-igg\n');
fprintf(fid, topHeaderStr, format);
fprintf(fid,'element vertex %d\n', nV);
fprintf(fid,'property float x\nproperty float y\nproperty float z\n');
if (writeVertexColors)
    fprintf(fid,'property uchar red\nproperty uchar green\nproperty uchar blue\n');
end % if
fprintf(fid,'element face %d\n', nF);
fprintf(fid,'property list uchar uint vertex_indices\n');
if (writeFaceColors)
    fprintf(fid,'property uchar red\nproperty uchar green\nproperty uchar blue\n');
end % if
fprintf(fid,'end_header\n');
% ------------------------------------------------------------------------

%-------------------------------------------------------------------------
%
% Write the Vertex list
%
for iV = 1:nV
    for i = 1:3
        fprintf(fid, '%.4f ', vertexList(iV,i));
    end
    
    if (writeVertexColors)
    for i=1:3
        fprintf(fid, '%d ', vertexColorList(iV,i));
    end % for
    end % if
    
    fprintf(fid, '\n');
end%for loop vertexList
% ------------------------------------------------------------------------

%-------------------------------------------------------------------------
%
% Write the Face list
% 
for iF = 1:nF
    [x, numberOfPolygonVertices] = size(faceList);
    %numberOfPolygonVertices = size(faceList,2)-1;
    fprintf(fid, '%d ', numberOfPolygonVertices);
    for i = 1:numberOfPolygonVertices
        fId = faceList(iF, i) - 1;
        %fId = faceList(iF, i);
        fprintf(fid, '%d ', fId);
    end
    
    if (writeFaceColors)
    for i=1:3
    %for i =1 : numberOfPolygonVertices
        fprintf(fid, '%d ', faceColorList(iF,i));
    end % for
    end % if
    
    fprintf(fid,'\n');
end%for loop faceList
%-------------------------------------------------------------------------

fclose(fid);

end%function exportPLY

