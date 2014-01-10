function [DenseVolume] = Interpolate3G(Volume, spaceStep, timeStep)
    
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
%     Interpolator = TriScatteredInterp(x,y,z,v,'nearest');
%     DenseVolumeScalar = Interpolator(xq, yq, zq);
    

    rbf = rbfcreate(SparsePoints, DeformScalar,'RBFFunction', 'multiquadratic', 'Stats', 'on');
    InterpolatedData = rbfinterp(DensePoints, rbf);
    DenseVolumeScalar = InterpolatedData';
    DensePoints = DensePoints';
     
    DenseVolume.DensePointsX = DensePointsX;
    DenseVolume.DensePointsY = DensePointsY;
    DenseVolume.DensePointsZ = DensePointsZ;
    DenseVolume.vxy = vxy;
    DenseVolume.vz = vz;
    
    DenseVolume.XYZ = DensePoints;    
    DenseVolume.DeformScalar = DenseVolumeScalar;
end % function