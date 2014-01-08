function [H] = Descriptor(V, objseq, DeformScalar, Adj, vi, fi, sigma, tau)

% Descriptor consists of histograms of gradients for each of 8 octets
% around the point of interest
H = cell(2, 4);

% Get spatio-temporal extents of characteristic region of interest point
[SurfPatch, Frames] = GetCharacteristicScale(V, Adj, vi, fi, sigma, tau);

% Flattening stage
XY = pca(SurfPatch.XYZ, 2);
SurfPatchFlat.XYZ = [XY zeros(size(XY, 1), 1)]; 
SurfPatchFlat.ID =  SurfPatch.ID;
% Get coordinates of the interest point
p = SurfPatchFlat.XYZ(1, :);

% Estimate the dominant orientation of gradient vectors within patch
[ePrime] = DominantOrientation(p, SurfPatchFlat, V, DeformScalar(:, fi), Adj);
% Rotate coordinate frame to follow dominant orientation
SurfPatchFlat.XYZ = ChangeBasis(SurfPatchFlat.XYZ, ePrime);

% Stack frames
Vol = GetCharacteristicVolume(SurfPatchFlat, Frames, DeformScalar);

Grad3 = Gradient3(Vol, DeformScalar, Adj);

% Histogram of gradient orientations within volume Vol
H = VolHistogramOfGradient(Vol, Grad3);

end % function

function [G] = Gradient3(Vol, DeformScalar, Adj)
numVert = size(Vol.XYZ, 1);

% Init gradient set
G = zeros(numVert, 3);

Pid = Vol.ID;
sizePid = size(Pid, 2);
for i = 1 : numVert
    id = mod(i, sizePid);
    if(id == 0)
        id = sizePid;
    end % if
    pid = Pid(id);
    
    f_i = Vol.XYZ(i, 3);
    [PosOfNeighb, ScalarOfNeighb] = RingNeighb3(pid, f_i, Vol, DeformScalar, Adj);
    G(i, :) = DiscreteGradient([DeformScalar(pid, f_i); ScalarOfNeighb], [Vol.XYZ(i,:); PosOfNeighb], 0);
end % for

end % function

function [H] = VolHistogramOfGradient(Vol, Grad3)
    X = Grad3(:, 1);
    Y = Grad3(:, 2);
    Z = Grad3(:, 3);

    [azimuth, elevation, r] = cart2sph(X,Y,Z);
    numberOfGradients = size(Grad3, 1);
    numberOfBins = 36;    
    H = zeros(numberOfBins);
    for i = 1 : numberOfGradients
        thetaId = ceil(azimuth * 18 / pi) + ceil(numberOfBins/2) * ones(numberOfGradients, 1);
        phiId = ceil(elevation * 36 / pi) + ceil(numberOfBins/2) * ones(numberOfGradients, 1);
        H(thetaId, phiId) = H(thetaId(i), phiId(i)) + norm(Grad3(i, :));
    end % for
    %hist3(H)
    
end % function

function [PosOfNeighb, ScalarOfNeighb] = RingNeighb3(pid, f_i, Vol, DeformScalar, Adj)
    Neighb = find(Adj(:, pid));
    NeighbID = find(ismember(Vol.ID, Neighb));
    PositionsID = find(Vol.XYZ(:, 3) == f_i);
    Positions = Vol.XYZ(PositionsID, :);        
    
    if(f_i > 1)    
        notFirstFrame = 1;
    else
        notFirstFrame = 0;
    end % if
    if(f_i < size(DeformScalar, 2))
        notLastFrame = 1;
    else
        notLastFrame = 0;
    end % if
    
    sizeOfNeighb = size(Neighb, 1) * (1 + notLastFrame + notFirstFrame);
    PosOfNeighb = zeros(sizeOfNeighb, 3);
    ScalarOfNeighb = zeros(sizeOfNeighb, 1);

    OneRingSubset = [1 : size(NeighbID, 2)]';
    
    PosOfNeighb(OneRingSubset, :) = Positions(NeighbID, :);    
    ScalarOfNeighb(OneRingSubset) = DeformScalar(NeighbID, f_i);
    
    sizeOfNeighb = size(NeighbID, 2);
    if(notFirstFrame)
        f_i = f_i - 1;
        OneRingSubset = OneRingSubset + sizeOfNeighb * ones(sizeOfNeighb, 1);
        PosOfNeighb(OneRingSubset, :) = Positions(NeighbID, :);
        PosOfNeighb(OneRingSubset, 3) = f_i * ones(sizeOfNeighb, 1);
        ScalarOfNeighb(OneRingSubset) = DeformScalar(NeighbID, f_i);
        f_i = f_i + 1;
    end %
    if(notLastFrame)
        f_i = f_i + 1;
        OneRingSubset = OneRingSubset + sizeOfNeighb * ones(sizeOfNeighb, 1);
        PosOfNeighb(OneRingSubset, :) = Positions(NeighbID, :);
        PosOfNeighb(OneRingSubset, 3) = f_i * ones(sizeOfNeighb, 1);
        ScalarOfNeighb(OneRingSubset) = DeformScalar(NeighbID, f_i);
        f_i = f_i - 1;
    end %
end % function

