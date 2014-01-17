function [euclideanNorm] = EMDHistogramNorm(DescrSrcCell, DescrTrgCell)

% Init
euclideanNorm = 0.0;

% Get descriptors
HoGSrcCell = DescrSrcCell(1, 1);
HoPSrcCell = DescrSrcCell(1, 2);
HoGTrgCell = DescrTrgCell(1, 1);
HoPTrgCell = DescrTrgCell(1, 2);

numOfOctants = size(HoGSrcCell{1, 1});
for i = 1 : numOfOctants
    HoGSrcOctant = HoGSrcCell{1, 1}{i, 1};
    HoPSrcOctant = HoPSrcCell{1, 1}{i, 1};
    HoGTrgOctant = HoGTrgCell{1, 1}{i, 1};
    HoPTrgOctant = HoPTrgCell{1, 1}{i, 1};
       
    % Linearize HoGs
    HoGSrcOctant = reshape(HoGSrcOctant, size(HoGSrcOctant, 1) * size(HoGSrcOctant, 2), 1);
    HoGTrgOctant = reshape(HoGTrgOctant, size(HoGTrgOctant, 1) * size(HoGTrgOctant, 2), 1);
    
    % Linearize HoPs
    HoPSrcOctant = reshape(HoPSrcOctant, size(HoPSrcOctant, 1) * size(HoPSrcOctant, 2), 1);
    HoPTrgOctant = reshape(HoPTrgOctant, size(HoPTrgOctant, 1) * size(HoPTrgOctant, 2), 1);
    
    fSrc = [1 : size(HoGSrcOctant, 1) * size(HoGSrcOctant, 2)]';
    fTrg = [1 : size(HoGTrgOctant, 1) * size(HoGTrgOctant, 2)]';
    [~, HoGDiff] = emd(fSrc, fTrg, HoGSrcOctant, HoGTrgOctant, @gdf);
    [~, HoPDiff] = emd(fSrc, fTrg, HoPSrcOctant, HoPTrgOctant, @gdf);
    
    global useHoG;
    global useHoP;
    if(useHoG)
        normHoG = HoGDiff;
    else
        normHoG = 0.0;
    end % if    
    if(useHoP)
        normHoP = HoPDiff;
    else
        normHoP = 0.0;
    end % if
    euclideanNorm = euclideanNorm + normHoG + normHoP;
end % for

end % function

