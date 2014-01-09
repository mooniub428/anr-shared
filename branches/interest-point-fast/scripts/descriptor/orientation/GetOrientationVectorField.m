% Compute dominanat orientation of gradients of scalar field sampled in
% nodes of regular 2d grid
%
function [orientation] = GetOrientationVectorField(DenseSurfPatchFlat, numOfBins, spaceStep)       
    [THETA, ~] = cart2pol(DenseSurfPatchFlat.DensePrincipalAxes(:, 1), ...
        DenseSurfPatchFlat.DensePrincipalAxes(:, 2));
    numOfPoints = numel(THETA);
    
    HistOfOrientation = zeros(numOfBins, 1);
    
    radialWidth = (2 * pi) / numOfBins;
    for i = 1 : numOfPoints
        angle = THETA(i);
        angle = (sign(angle)==1) * angle + (sign(angle)==-1) * (2*pi + angle);
        bin_id = ceil(angle / radialWidth);
        if(bin_id == 0)
            bin_id = 1;
        end % if
        
        theCenter = DenseSurfPatchFlat.XYZCentroid(i, :);
        theVector = DenseSurfPatchFlat.DensePrincipalAxes(i, :);
        HistOfOrientation(bin_id) = HistOfOrientation(bin_id) + norm(theVector) * norm(theCenter);
    end % for
    
    maxBinId = find(HistOfOrientation == max(HistOfOrientation));
    maxBinId = maxBinId(1);
    angle = (maxBinId - 0.5) * radialWidth;
    R = [[cos(angle) -sin(angle) 0];[sin(angle) cos(angle) 0];[0 0 1]];
    orientation = R * [1 0 0]';
    orientation = orientation';    
end % function