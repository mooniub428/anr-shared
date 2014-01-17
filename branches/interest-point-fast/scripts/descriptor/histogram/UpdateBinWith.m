function [Histograms] = UpdateBinWith(gradient, point, Histograms, octantId, octantCenter, radialWidth)
    [THETAGrad, PHIGrad, ~] = cart2sph(gradient(1), gradient(2), gradient(3));
    
    [binIdTHETA, binIdPHI] = GetBinId(THETAGrad, PHIGrad, radialWidth);
    
    H = cell2mat(Histograms(octantId));
    
    global normalizeSolidAngle;
    if(normalizeSolidAngle)        
        %phi is elevation, theta is azimuth
        omega = SolidAngle(PHIGrad, radialWidth, radialWidth);
    else
        omega = 1.0;
    end % if
    H(binIdTHETA, binIdPHI) = (H(binIdTHETA, binIdPHI) + norm(gradient) * norm(point - octantCenter)) * omega;
    Histograms(octantId) = {H};
end % function