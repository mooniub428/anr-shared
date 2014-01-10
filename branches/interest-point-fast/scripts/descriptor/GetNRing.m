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