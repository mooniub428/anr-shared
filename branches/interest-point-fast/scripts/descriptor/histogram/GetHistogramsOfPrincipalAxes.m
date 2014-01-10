function [Histograms] = GetHistogramsOfPrincipalAxes(Volume, numOfBins)
% Histograms are composed in 8 octants as in 3D SIFT
    Histograms = cell(8, 1);
    % Init histograms
    for i = 1 : 8        
        Histograms(i) = mat2cell(zeros(numOfBins, numOfBins/2));        
    end % for
    
    numOfCentroids = size(Volume.XYZCentroid, 1);
    % Transform Cartesian coordinates of samples to spherical
    [azimuth, elevation, ~] = cart2sph(Volume.XYZCentroid(:, 1), Volume.XYZCentroid(:, 2), Volume.XYZCentroid(:, 3));
    
    for i = 1 : numOfCentroids
        THETA = azimuth(i);
        PHI = elevation(i);
        
        % Determine octant        
        [octantId, octantCenter] = GetOctantId(THETA, PHI, Volume);
                
        % Determine bin 
        radialWidth = 2 * pi / numOfBins;        

        % Update the bin in corresponding octant
        theAxis = Volume.PrincipalAxes(i, :);
        point = Volume.XYZCentroid(i, :);
        Histograms = UpdateBinWith(theAxis, point, Histograms, octantId, octantCenter, radialWidth);                                        
    end % for
end % function

