% Create a maxscript file to create splines which resemle principal strain
% axes
function [] = ExportDeformationAxes(objseq, param, D, E, fi)

% Reatain vertex coordinates only in a frame of interest
vertices = squeeze(objseq.V(:, :, fi));
% Retain only principal strain values only for frame of interest
D = D(:, fi);
% Retain only axes in bar coord for the frame of interest
E = cell2mat(squeeze(E(:,2)));
% Number of deformed triangles i.e. their strain values are over threshold
numOfDeformed = sum(D > param.strain_min); 

% Principal strain axes start points
VectorsStart = zeros(numOfDeformed, 3);
VectorsEnd = zeros(numOfDeformed, 3);

numOfTriangles = size(objseq.triangles, 1);
vectorsCounter = 1;
for i = 1 : numOfTriangles
    principalStrainValue = D(i);
    if(principalStrainValue >= param.strain_min)
        Triangle = vertices(objseq.triangles(i, :)', :);
        VectorsStart(vectorsCounter, :) = Centroid(Triangle);
        VectorsEnd(vectorsCounter, :) = Barycentric2Cartesian(E(i, :), Triangle);
        vectorsCounter = vectorsCounter + 1;
    end % if
end % for

% Generate maxscript
Vectors2MaxscriptSplines(VectorsStart, VectorsEnd);

end % function

