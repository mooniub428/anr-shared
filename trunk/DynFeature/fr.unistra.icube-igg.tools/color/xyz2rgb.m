% Computes color map corresponding to 3D position of points in space
function [ RGB ] = xyz2rgb( XYZ )
% Nimber of points
n = size(XYZ, 1);

% Perform linear shift of the set of points to make their 3d coordinates
% non-negative
MinV = min(XYZ, [], 1);
MIN = zeros(n, 3);
for i = 1 : n
    MIN(i, :) = MinV;
end % for
MIN = abs(MIN);
XYZ = XYZ + MIN;

% Normalize coordinates along each dimension separately
for i = 1 : 3
    maxd = max(XYZ(:, i));
    XYZ(:, i) = XYZ(:, i) / maxd;
end % for

% Compute RGB values from XYZ
RGB = round(XYZ * 255);

end % function

