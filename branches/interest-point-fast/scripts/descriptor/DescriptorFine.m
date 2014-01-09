function [Histogra  ms] = DescriptorFine(Vertices, VerticesOverFrames, DeformScalar, Adj, vi, fi, sigma, tau)
    % Get local surface patch at characteristic scales
    [SurfPatch, Frames] = GetSurfacePatch(Vertices, Adj, vi, sigma, tau);
    % Flattening stage
    SurfPatch.XYZ
    XY = pca(SurfPatch.XYZ, 2);
    SurfPatchFlat.XYZ = [XY zeros(size(XY, 1), 1)]; 
    SurfPatchFlat.ID =  SurfPatch.ID;

    spaceStep = 0.1;
    timeStep = 0.2;
    
    % Get coordinates of the interest point    
    [SurfPatchFlat] = TranslateRotateScale(SurfPatchFlat, [1 0 0]);
    DenseSurfPatchFlat = interpolate2(SurfPatchFlat, DeformScalar(SurfPatchFlat.ID', fi), spaceStep);
    
    % Get dominant orientation with respect to gradients of surfaces
    % deformation values
    numOfBins = 18;
    orientation = GetOrientationScalarField(DenseSurfPatchFlat, numOfBins, spaceStep);

    SurfPatchFlat = TranslateRotateScale(SurfPatchFlat, orientation);
        
    [GradientsFull, Volume] = GetFullVolumeGradients(SurfPatchFlat, DeformScalar, Frames, spaceStep, timeStep);
            
    Histograms = GetHistograms(GradientsFull, Volume, numOfBins);  
    Histograms = InterpolateAllHistograms(Histograms);
end % function

% Unfinished
function [SurfPatch, Frames] = GetSurfacePatch(Vertices, Adj, vi, sigma, tau)
    numVertices = size(Vertices, 1);
       
    %ID = find(Adj(:, vi));
    ID = GetNRing(Adj, vi, 2)
    
    XYZ = Vertices(ID, :);
        
    XYZ = [Vertices(vi, :); XYZ];
    SurfPatch.XYZ = XYZ;
    
    SurfPatch.ID = [vi ID'];
    
    Frames = [1 2 3 4];
end % function

%%
function [DenseSurfPatchFlat] = interpolate2(SurfPatchFlat, DeformScalar, spaceStep)
    %DeformScalar = DeformScalar(SurfPatchFlat.ID');
    DeformScalar = DeformScalar';
    SparsePoints = SurfPatchFlat.XYZ(:, 1:2)';
    v = -0.5 : spaceStep : 0.5;
    [DensePointsX, DensePointsY] = meshgrid(v);
    DensePoints = grid22vec2(DensePointsX, DensePointsY);
    DensePoints = DensePoints';
    
    % Old interpolation scheme, which always works, but does not yield the
    % most precise results
    % DenseDeformScalar = griddata(SparsePoints(1,:), SparsePoints(2,:), DeformScalar, DensePoints(1,:), DensePoints(2,:), 'v4')';
    
    % First Kriging trials (not the most optimal implementation)
%     pos_known = SparsePoints';
%     val_kn = DeformScalar'; % adding some uncertainty
%     V='1 Sph(.2)';      % Select variogram model
%     V = '1 Lin(1)';
%     pos_est = DensePoints';
%     [d_est,d_var]=krig(pos_known,val_known,pos_est,V)

    
    % Old rbf interpolation method    
    %rbf = rbfcreate(SparsePoints, DeformScalar,'RBFFunction', 'multiquadric', 'Stats', 'on');     
    %DenseDeformScalar = rbfinterp( DensePoints, rbf);    
    
    % Do good RBF interpolation
    [x,y,z] = rbf(SparsePoints(1,:)', SparsePoints(2, :)', DeformScalar', DensePointsX, DensePointsY, 'multiquadratic');
    InterpolatedData = grid32vec3(x, y, z);
    DenseDeformScalar = InterpolatedData(:, 3);
    
    %DenseDeformScalar = DenseDeformScalar';       
    DensePoints = DensePoints';
     
    DenseSurfPatchFlat.v = v;
    DenseSurfPatchFlat.XYZ = [DensePoints zeros(size(DensePoints, 1), 1)];
    DenseSurfPatchFlat.DeformScalar = DenseDeformScalar;
end % function

%%
% function [orientation] = GetOrientation(DenseSurfPatchFlat, numOfBins, spaceStep)       
%     [gx, gy] = gradient(vec12grid2(DenseSurfPatchFlat.DeformScalar), spaceStep, spaceStep);
%     %quiver(DenseSurfPatchFlat.v, DenseSurfPatchFlat.v, gx, gy)
%     DenseSurfPatchFlat.Gradient = grid22vec2(gx, gy);
% 
%     [THETA, ~] = cart2pol(DenseSurfPatchFlat.Gradient(:, 1), DenseSurfPatchFlat.Gradient(:, 2));
%     numOfPoints = numel(THETA);
%     
%     HistOfGradient = zeros(numOfBins, 1);
%     
%     radialWidth = (2 * pi) / numOfBins;
%     for i = 1 : numOfPoints
%         angle = THETA(i);
%         angle = (sign(angle)==1) * angle + (sign(angle)==-1) * (2*pi + angle);
%         bin_id = ceil(angle / radialWidth);
%         if(bin_id == 0)
%             bin_id = 1;
%         end % if
%         
%         thePoint = DenseSurfPatchFlat.XYZ(i, :);
%         theGradient = DenseSurfPatchFlat.Gradient(i, :);
%         HistOfGradient(bin_id) = HistOfGradient(bin_id) + norm(theGradient) * norm(thePoint);
%     end % for
%     
%     maxBinId = find(HistOfGradient == max(HistOfGradient));
%     maxBinId = maxBinId(1);
%     angle = (maxBinId - 0.5) * radialWidth;
%     R = [[cos(angle) -sin(angle) 0];[sin(angle) cos(angle) 0];[0 0 1]];
%     orientation = R * [1 0 0]';
%     orientation = orientation';    
% end % function

%%
function [GradientsFull, Volume] = GetFullVolumeGradients(SurfPatchFlat, DeformScalar, Frames, spaceStep, timeStep)
    numOfPoints = size(SurfPatchFlat.XYZ, 1);
    numOfFrames = size(Frames, 2);
    
    % Construct characteristic volume    
    Volume.XYZ = repmat(SurfPatchFlat.XYZ, numOfFrames, 1);
    Volume.DeformScalar = zeros(numOfPoints * numOfFrames, 1);
    counter = 1;
    for fi = Frames
        Volume.XYZ((counter -1) * numOfPoints + 1 : counter * numOfPoints, 3) = (timeStep * fi) * ones(numOfPoints, 1);
        Volume.DeformScalar((counter -1) * numOfPoints + 1 : counter * numOfPoints, 1) = DeformScalar(SurfPatchFlat.ID', fi);
        counter = counter + 1;
    end % for
    % Shift to the center
    Volume.XYZ(:, 3) = Volume.XYZ(:, 3) - mean(Volume.XYZ(:, 3)) * ones(numOfPoints * numOfFrames, 1);
    upperMargin = max(Volume.XYZ(:, 3));
    Volume.upperMargin = upperMargin;
    
    % Interpolate
    DenseVolume = interpolate3(Volume, spaceStep, timeStep);        
    
    % Compute gradient
    nx = numel(DenseVolume.vxy);
    ny = numel(DenseVolume.vxy);
    nz = numel(DenseVolume.vz);
    
    [gx, gy, gz] = gradient(DenseVolume.DeformScalar, spaceStep, spaceStep, timeStep);
    %[gx, gy, gz] = gradient(vec12grid3(DenseVolume.DeformScalar, nx, ny, nz), spaceStep, spaceStep, timeStep);
    
    quiver3(DenseVolume.DensePointsX, DenseVolume.DensePointsY, DenseVolume.DensePointsZ, gx, gy, gz);
    
    GradientsFull.Gradients = grid32vec3(gx, gy, gz);
    GradientsFull.XYZ = grid32vec3(DenseVolume.DensePointsX, DenseVolume.DensePointsY, DenseVolume.DensePointsZ);
end % function
%%
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
        Histograms = updateBinWith(gradient, point, Histograms, octantId, octantCenter, radialWidth);                                        
    end % for
end % function

function [Histograms] = updateBinWith(gradient, point, Histograms, octantId, octantCenter, radialWidth)
    [THETAGrad, PHIGrad, ~] = cart2sph(gradient(1), gradient(2), gradient(3));
    [binIdTHETA, binIdPHI] = GetBinId(THETAGrad, PHIGrad, radialWidth);
    H = cell2mat(Histograms(octantId));
    H(binIdTHETA, binIdPHI) = H(binIdTHETA, binIdPHI) + norm(gradient) * norm(point - octantCenter);
    Histograms(octantId) = mat2cell(H);
end % function

% 
function [octantId, octantCenter] = GetOctantId(THETA, PHI, Volume)
    if(PHI >= 0)
        if(THETA > 0)
            if(THETA < pi/2)
                octantId = 1;
                octantCenter = [0.5 0.5 Volume.upperMargin/2];
            else
                octantId = 2;
                octantCenter = [-0.5 0.5 Volume.upperMargin/2];
            end % if
        else
            if(THETA < -pi/2)
                octantId = 3;
                octantCenter = [-0.5 -0.5 Volume.upperMargin/2];
            else
                octantId = 4;
                octantCenter = [0.5 -0.5 Volume.upperMargin/2];
            end % if
        end % if
    else
        if(THETA > 0)
            if(THETA < pi/2)
                octantId = 5;
                octantCenter = [0.5 0.5 -Volume.upperMargin/2];
            else
                octantId = 6;
                octantCenter = [-0.5 0.5 Volume.upperMargin/2];
            end % if
        else
            if(THETA < -pi/2)
                octantId = 7;
                octantCenter = [-0.5 -0.5 Volume.upperMargin/2];
            else
                octantId = 8;
                octantCenter = [0.5 -0.5 Volume.upperMargin/2];
            end % if
        end % if
    end % if
end % function

function [binIdTHETA, binIdPHI] = GetBinId(THETAGrad, PHIGrad, radialWidth)
    THETAGrad = (sign(THETAGrad)==1) * THETAGrad + (sign(THETAGrad)==-1) * (2*pi + THETAGrad);
    PHIGrad = (sign(PHIGrad)==1) * PHIGrad + (sign(PHIGrad)==-1) * (pi + PHIGrad);
    
    binIdTHETA = ceil(THETAGrad / radialWidth);
    binIdTHETA = binIdTHETA + (binIdTHETA == 0);
    
    binIdPHI = ceil(PHIGrad / radialWidth);
    binIdPHI = binIdPHI + (binIdPHI == 0);
end % function

function [NRingPointIds] = GetNRing(AdjMatrix, vi, n)
    NRingPointIds = [];
    if(n == 1)
        NRingPointIds = GetOneRing(AdjMatrix, vi);
    else
        OneRingPointIds = GetOneRing(AdjMatrix, vi);
        numOfOneRingPoints = numel(OneRingPointIds);
        for i = 1 : numOfOneRingPoints
            nextVi = OneRingPointIds(i);
            NRingPointIds = [NRingPointIds; nextVi; GetNRing(AdjMatrix, nextVi, n - 1)];
        end % for
    end %if
    NRingPointIds = unique(NRingPointIds);
end % function

function [OneRingPointIds] = GetOneRing(AdjMatrix, vi)
    OneRingPointIds = find(AdjMatrix(:, vi));
end % function