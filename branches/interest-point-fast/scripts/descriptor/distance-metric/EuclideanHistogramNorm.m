function [euclideanNorm] = EuclideanHistogramNorm(DescrSrcCell, DescrTrgCell)

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
    
    % Compute differences
    HoGDiff = HoGSrcOctant - HoGTrgOctant;
    HoPDiff = HoPSrcOctant - HoPTrgOctant;
    % Linearize
    HoGDiff = reshape(HoGDiff, size(HoGDiff, 1) * size(HoGDiff, 2), 1);
    HoPDiff = reshape(HoPDiff, size(HoPDiff, 1) * size(HoPDiff, 2), 1);
    
    global useHoG;
    global useHoP;
    if(useHoG)
        normHoG = norm(HoGDiff);
    else
        normHoG = 0.0;
    end % if    
    if(useHoP)
        normHoP = norm(HoPDiff);
    else
        normHoP = 0.0;
    end % if
    euclideanNorm = euclideanNorm + 0.9 * normHoG + 0.1 * normHoP;
end % for

end % function

