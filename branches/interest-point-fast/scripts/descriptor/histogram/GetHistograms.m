function [Histograms] = GetHistograms(GradientsFull, Volume, numOfBins)
    % Histograms are composed in 8 octants as in 3D SIFT
    Histograms = cell(8, 1);
    % Init histograms
    for i = 1 : 8        
        Histograms(i) = mat2cell(zeros(numOfBins, numOfBins/2));        
    end % for
    
    % Number of points/samples in which gradients were estimated
    numOfPoints = size(GradientsFull.XYZ, 1);
    % Transform Cartesian coordinates of samples to spherical
    [azimuth, elevation, ~] = cart2sph(GradientsFull.XYZ(:, 1), GradientsFull.XYZ(:, 2), GradientsFull.XYZ(:, 3));
    
    for i = 1 : numOfPoints
        THETA = azimuth(i);
        PHI = elevation(i);
        
        % Determine octant        
        [octantId, octantCenter] = GetOctantId(THETA, PHI, Volume);
                
        % Determine bin 
        radialWidth = 2 * pi / numOfBins;        

        % Update the bin in corresponding octant
        gradient = GradientsFull.Gradients(i, :);
        point = GradientsFull.XYZ(i, :);
        Histograms = UpdateBinWith(gradient, point, Histograms, octantId, octantCenter, radialWidth);                                        
    end % for
end % function