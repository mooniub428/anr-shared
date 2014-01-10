function [binIdTHETA, binIdPHI] = GetBinId(THETAGrad, PHIGrad, radialWidth)
    THETAGrad = (sign(THETAGrad)==1) * THETAGrad + (sign(THETAGrad)==-1) * (2*pi + THETAGrad);
    PHIGrad = (sign(PHIGrad)==1) * PHIGrad + (sign(PHIGrad)==-1) * (pi + PHIGrad);
    
    binIdTHETA = ceil(THETAGrad / radialWidth);
    binIdTHETA = binIdTHETA + (binIdTHETA == 0);
    
    binIdPHI = ceil(PHIGrad / radialWidth);
    binIdPHI = binIdPHI + (binIdPHI == 0);
end % function