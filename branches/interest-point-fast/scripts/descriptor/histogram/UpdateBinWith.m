function [Histograms] = UpdateBinWith(gradient, point, Histograms, octantId, octantCenter, radialWidth)
    [THETAGrad, PHIGrad, ~] = cart2sph(gradient(1), gradient(2), gradient(3));
    [binIdTHETA, binIdPHI] = GetBinId(THETAGrad, PHIGrad, radialWidth);
    H = cell2mat(Histograms(octantId));
    H(binIdTHETA, binIdPHI) = H(binIdTHETA, binIdPHI) + norm(gradient) * norm(point - octantCenter);
    Histograms(octantId) = {H};
end % function