function [OneRingPointIds] = GetOneRing(AdjMatrix, vi)
    OneRingPointIds = find(AdjMatrix(:, vi));
end % function