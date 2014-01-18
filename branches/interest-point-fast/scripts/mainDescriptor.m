% Load dependencies
load_coretools();

% Load configuration
dataNameSrc = 'cylinder';
dataNameTrg = 'cylindernew';
%data_name = 'horse';
%data_name = 'camel';

global smoothingStrength;
global useHoG;
global useHoP;
global numOfBins;
global normalizeSolidAngle;
smoothingStrength = 0.3;
DescrUseEMD = false;
useHoG = true;
useHoP = true;
numOfBins = 10;
normalizeSolidAngle = false;
crossValidation = false;


viSrc = [263 245 478 299 293 251]';
viTrg = [227 198 395 262 257 215]';
fi = 23;

if(crossValidation)
    swap = viSrc;
    viSrc = viTrg;
    viTrg = swap;
    swap = dataNameSrc;
    dataNameSrc = dataNameTrg;
    dataNameTrg = swap;
end % if

DescriptorsSrc = GetDescriptors(dataNameSrc, viSrc, fi);
DescriptorsTrg = GetDescriptors(dataNameTrg, viTrg, fi);

Descriptors.viSrc = viSrc;
Descriptors.viTrg = viTrg;
Descriptors.fi = fi;
% Free memory
clearvars -except Descr*
viSrc = Descriptors.viSrc;
viTrg = Descriptors.viTrg;
fi = Descriptors.fi;

numOfVert = numel(viSrc);
Matches = zeros(numOfVert, 1);
Distances = zeros(numOfVert, 1);
for i = 1 : numOfVert
    distance = Inf;
    matchId = 0;
    for j = 1 : numOfVert
        if(DescrUseEMD)
            newDistance = EMDHistogramNorm(DescriptorsSrc(i, :), DescriptorsTrg(j, :));
        else
            newDistance = EuclideanHistogramNorm(DescriptorsSrc(i, :), DescriptorsTrg(j, :));
        end % if
        if(newDistance < distance)
            distance = newDistance;
            matchId = j;
        end % if
    end % for
    Matches(i) = matchId;
    Distances(i) = distance;
end % for

[viSrc Matches Distances]


