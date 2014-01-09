% Compute dominanat orientation of gradients of scalar field sampled in
% nodes of regular 2d grid
%
function [orientation] = GetOrientationScalarField(DenseSurfPatchFlat, numOfBins, spaceStep)       
    [gx, gy] = gradient(vec12grid2(DenseSurfPatchFlat.DeformScalar), spaceStep, spaceStep);
    %quiver(DenseSurfPatchFlat.v, DenseSurfPatchFlat.v, gx, gy)
    DenseSurfPatchFlat.Gradient = grid22vec2(gx, gy);

    [THETA, ~] = cart2pol(DenseSurfPatchFlat.Gradient(:, 1), DenseSurfPatchFlat.Gradient(:, 2));
    numOfPoints = numel(THETA);
    
    HistOfGradient = zeros(numOfBins, 1);
    
    radialWidth = (2 * pi) / numOfBins;
    for i = 1 : numOfPoints
        angle = THETA(i);
        angle = (sign(angle)==1) * angle + (sign(angle)==-1) * (2*pi + angle);
        bin_id = ceil(angle / radialWidth);
        if(bin_id == 0)
            bin_id = 1;
        end % if
        
        thePoint = DenseSurfPatchFlat.XYZ(i, :);
        theGradient = DenseSurfPatchFlat.Gradient(i, :);
        HistOfGradient(bin_id) = HistOfGradient(bin_id) + norm(theGradient) * norm(thePoint);
    end % for
    
    maxBinId = find(HistOfGradient == max(HistOfGradient));
    maxBinId = maxBinId(1);
    angle = (maxBinId - 0.5) * radialWidth;
    R = [[cos(angle) -sin(angle) 0];[sin(angle) cos(angle) 0];[0 0 1]];
    orientation = R * [1 0 0]';
    orientation = orientation';    
end % function