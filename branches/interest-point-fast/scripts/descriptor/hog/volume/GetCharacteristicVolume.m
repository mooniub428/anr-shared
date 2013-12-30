function [Vol] = GetCharacteristicVolume(SurfPatchFlat, Frames, DeformScalar)

X = SurfPatchFlat.XYZ(:, 1);
Y = SurfPatchFlat.XYZ(:, 2);
Z = SurfPatchFlat.XYZ(:, 3);

numPoints = size(SurfPatchFlat.ID, 2);
numFrames = size(Frames, 2);

Vol.DeformScalar = zeros(numPoints, numFrames);
nextFrame = 1;
Vol.XYZ = zeros(numPoints, 3, numFrames);
for f_i = Frames
    Vol.XYZ(:, :, nextFrame) = SurfPatchFlat.XYZ(:, :);
    Vol.XYZ(:, 3, nextFrame) = f_i * ones(numPoints, 1);
    Vol.DeformScalar(:, nextFrame) = DeformScalar(SurfPatchFlat.ID', f_i);
    nextFrame = nextFrame + 1;
end % for

Vol.ID = SurfPatchFlat.ID;

end % function

