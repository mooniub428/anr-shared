% Compute max distance between vertices (i.e. max diagonal of the bounding
% box)
function [ d ] = max_diag_bbox( vertices )

% Implementation takes advantage of the fact that distance
dist_mtr = pdist(vertices);

d = max(dist_mtr);

end

