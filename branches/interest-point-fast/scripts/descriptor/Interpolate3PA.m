function [DenseVolume] = Interpolate3PA(Volume, spaceStep, timeStep)
    DenseVolume = Volume;

    SparsePoints = Volume.XYZCentroid';
    vxy = -0.5 : spaceStep : 0.5;
    vz = -Volume.upperMargin : timeStep : Volume.upperMargin;
    
    [DensePointsX, DensePointsY, DensePointsZ] = meshgrid(vxy, vxy, vz);
    
    DensePoints = grid32vec3(DensePointsX, DensePointsY, DensePointsZ);
    DensePoints = DensePoints';
           
    x = SparsePoints(1,:)';
    y = SparsePoints(2,:)';
    z = SparsePoints(3,:)';
    
    xq = DensePointsX;
    yq = DensePointsY;
    zq = DensePointsZ;
    
     RBFFunction = 'multiquadratic';
     rbf_x = rbfcreate(SparsePoints, Volume.PrincipalAxes(:, 1)','RBFFunction', RBFFunction, 'Stats', 'on');
     rbf_y = rbfcreate(SparsePoints, Volume.PrincipalAxes(:, 2)','RBFFunction', RBFFunction, 'Stats', 'on');    
     rbf_z = rbfcreate(SparsePoints, Volume.PrincipalAxes(:, 3)','RBFFunction', RBFFunction, 'Stats', 'on'); 
  
     x = rbfinterp(DensePoints, rbf_x);
     y = rbfinterp(DensePoints, rbf_y);
     z = rbfinterp(DensePoints, rbf_z);
     
    DenseVolume.XYZCentroid = DensePoints';
    DenseVolume.PrincipalAxes = [x' y' z'];
end % function