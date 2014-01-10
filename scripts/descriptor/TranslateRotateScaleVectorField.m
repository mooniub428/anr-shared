% Translate surface patch SurfacePatch to centerPoint
% Rotate the world coordinate system x
function [SurfacePatch] = TranslateRotateScaleVectorField(SurfacePatch, orientation)

Points = SurfacePatch.XYZ;
Centroids = SurfacePatch.XYZCentroid;
% Translate
centerPoint = SurfacePatch.XYZ(1, :);
Points = Points - repmat(centerPoint, size(Points, 1), 1);
Centroids = Centroids - repmat(centerPoint, size(Centroids, 1), 1);

% Rotate
angle = cart2pol(orientation(1), orientation(2), orientation(3));
R = [[cos(angle) -sin(angle) 0];[sin(angle) cos(angle) 0];[0 0 1]];
Points = R * Points';
Points = Points';
Centroids = R * Centroids';
Centroids = Centroids';

% Scale
%Points = Points / (2 * max(pdist(Points, 'euclidean')));
Points = Points / (2 * max(abs(Points(:, 1))));
Centroids = Centroids / (2 * max(abs(Centroids(:, 1))));

SurfacePatch.XYZ = Points;
SurfacePatch.XYZCentroid = Centroids;

end % function

