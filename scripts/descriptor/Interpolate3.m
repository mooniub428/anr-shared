function [DenseVolume] = interpolate3(Volume, spaceStep, timeStep)
    
    DeformScalar = Volume.DeformScalar';
    
    SparsePoints = Volume.XYZ';
    vxy = -0.5 : spaceStep : 0.5;
    vz = -Volume.upperMargin : timeStep : Volume.upperMargin;
    
    [DensePointsX, DensePointsY, DensePointsZ] = meshgrid(vxy, vxy, vz);
    
    DensePoints = grid32vec3(DensePointsX, DensePointsY, DensePointsZ);
    DensePoints = DensePoints';
           
    x = SparsePoints(1,:)';
    y = SparsePoints(2,:)';
    z = SparsePoints(3,:)';
    v = DeformScalar';
    xq = DensePointsX;
    yq = DensePointsY;
    zq = DensePointsZ;
    Interpolator = TriScatteredInterp(x,y,z,v,'nearest');
    DenseVolumeScalar = Interpolator(xq, yq, zq);
    
%     RBFFunction = GetRBFunction();
%     rbf_x = rbfcreate(SparsePoints, DeformScalar,'RBFFunction', RBFFunction, 'Stats', 'on');
%     rbf_y = rbfcreate(SparsePoints, DeformScalar,'RBFFunction', RBFFunction, 'Stats', 'on');    
%     rbf_z = rbfcreate(SparsePoints, DeformScalar,'RBFFunction', RBFFunction, 'Stats', 'on'); 
%  
%     x = rbfinterp(DensePoints, rbf_x);
%     y = rbfinterp(DensePoints, rbf_y);
%     z = rbfinterp(DensePoints, rbf_z);
%     
%     DenseDeformScalar = x';
    DensePoints = DensePoints';
     
    DenseVolume.DensePointsX = DensePointsX;
    DenseVolume.DensePointsY = DensePointsY;
    DenseVolume.DensePointsZ = DensePointsZ;
    DenseVolume.vxy = vxy;
    DenseVolume.vz = vz;
    
    DenseVolume.XYZ = DensePoints;
    %DenseVolume.DeformScalar = DenseDeformScalar;
    DenseVolume.DeformScalar = DenseVolumeScalar;
end % function