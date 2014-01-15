% Compute 2d radial histogram descriptor based on surface deformation
% principal axes
function [Histograms] = DescriptorPrincipalAxes(Vertices, Triangles, E, Adj, vi, fi, sigma, tau, param)
    % Get local triangle patch around the interest point
    [LocalPatch, Frames] = GetTriPatch(Vertices, Triangles, Adj, vi, sigma, tau);
    
    % Flatten vertices within the patch    
    XY = pca([LocalPatch.XYZ; LocalPatch.XYZCentroid], 2);
    numOfPoints = size(LocalPatch.XYZ, 1);
    numOfCentr = size(XY, 1) - numOfPoints;
    LocalPatchFlat = LocalPatch;
    LocalPatchFlat.XYZ = [XY(1 : numOfPoints, :) zeros(numOfPoints, 1)];     
    LocalPatchFlat.XYZCentroid = [XY(numOfPoints + 1 : numOfPoints + numOfCentr, :) zeros(numOfCentr, 1)];     
    
    spaceStep = 0.1;
    timeStep = 0.2;
    
    % Compute principal directions with respect to their barycentric
    % coordinates LocalPatchFlat.PrincipalAxes
    LocalPatchFlat = GetPrincipalAxesFromBarycentric(LocalPatchFlat, Triangles, E, fi);
    TranslateRotateScaleVectorField(LocalPatchFlat, [1 0 0]);
    Vectors2MaxscriptSplines(LocalPatchFlat.XYZCentroid, LocalPatchFlat.XYZCentroid + LocalPatchFlat.PrincipalAxes);
    DenseLocalPatchFlat = Interpolate2PA(LocalPatchFlat, spaceStep);
    
    % Get dominant orientation with respect to gradients of surfaces
    % deformation values
    numOfBins = 18;
    orientation = GetOrientationVectorField(DenseLocalPatchFlat, numOfBins, spaceStep);

    LocalPatchFlat = TranslateRotateScaleVectorField(LocalPatchFlat, orientation);
        
    if(param.interpolate_3d)
        [Volume] = GetFullVolumeVectorField(LocalPatchFlat, Triangles, E, orientation, Frames, spaceStep, timeStep);
    else
        [Volume] = GetFullVolumePatchwise(LocalPatchFlat, Triangles, E, orientation, Frames, spaceStep, timeStep);
    end % if
            
    Histograms = GetHistogramsOfPrincipalAxes(Volume, numOfBins);  
    Histograms = InterpolateAllHistograms(Histograms);
end % function

