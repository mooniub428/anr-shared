function [Histograms] = DescriptorFine(Vertices, DeformScalar, Adj, vi, fi, sigma, tau, param)
    % Get local surface patch at characteristic scales
    [SurfPatch, Frames] = GetSurfacePatch(Vertices, Adj, vi, sigma, tau);
    % Flattening stage
    SurfPatch.XYZ
    XY = pca(SurfPatch.XYZ, 2);
    SurfPatchFlat.XYZ = [XY zeros(size(XY, 1), 1)]; 
    SurfPatchFlat.ID =  SurfPatch.ID;

    spaceStep = param.space_step;
    timeStep = param.time_step;
    
    % Get coordinates of the interest point    
    [SurfPatchFlat] = TranslateRotateScaleScalarField(SurfPatchFlat, [1 0 0]);
    DenseSurfPatchFlat = interpolate2(SurfPatchFlat, DeformScalar(SurfPatchFlat.ID', fi), spaceStep);
    
    % Get dominant orientation with respect to gradients of surfaces
    % deformation values
    numOfBins = 18;
    orientation = GetOrientationScalarField(DenseSurfPatchFlat, numOfBins, spaceStep);

    SurfPatchFlat = TranslateRotateScaleScalarField(SurfPatchFlat, orientation);
        
    [GradientsFull, Volume] = GetFullVolumeGradients(SurfPatchFlat, DeformScalar, Frames, spaceStep, timeStep);
            
    Histograms = GetHistogramsOfGradients(GradientsFull, Volume, numOfBins);  
    Histograms = InterpolateAllHistograms(Histograms);
end % function

% Unfinished
function [SurfPatch, Frames] = GetSurfacePatch(Vertices, Adj, vi, sigma, tau)
    numVertices = size(Vertices, 1);
       
    %ID = find(Adj(:, vi));
    ID = GetNRing(Adj, vi, 2)
    ID = ID(ID~=vi);
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
    rbf = rbfcreate(SparsePoints, DeformScalar,'RBFFunction', 'multiquadratic', 'Stats', 'on');     
    DenseDeformScalar = rbfinterp( DensePoints, rbf);    
    
    % Do good RBF interpolation
    %[x,y,z] = rbf(SparsePoints(1,:)', SparsePoints(2, :)', DeformScalar', DensePointsX, DensePointsY, 'multiquadratic');
    %InterpolatedData = grid32vec3(x, y, z);
    %DenseDeformScalar = InterpolatedData(:, 3);
    
    %DenseDeformScalar = DenseDeformScalar';       
    DensePoints = DensePoints';
     
    DenseSurfPatchFlat.v = v;
    DenseSurfPatchFlat.XYZ = [DensePoints zeros(size(DensePoints, 1), 1)];
    DenseSurfPatchFlat.DeformScalar = DenseDeformScalar;
end % function


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
    DenseVolume = Interpolate3G(Volume, spaceStep, timeStep);        
    
    % Compute gradient
    nx = numel(DenseVolume.vxy);
    ny = numel(DenseVolume.vxy);
    nz = numel(DenseVolume.vz);
        
    % [gx, gy, gz] = gradient(DenseVolume.DeformScalar, spaceStep, spaceStep, timeStep);
    [gx, gy, gz] = gradient(vec12grid3(DenseVolume.DeformScalar, nx, ny, nz), spaceStep, spaceStep, timeStep);
    
    quiver3(DenseVolume.DensePointsX, DenseVolume.DensePointsY, DenseVolume.DensePointsZ, gx, gy, gz);
    
    GradientsFull.Gradients = grid32vec3(gx, gy, gz);
    GradientsFull.XYZ = grid32vec3(DenseVolume.DensePointsX, DenseVolume.DensePointsY, DenseVolume.DensePointsZ);
end % function
