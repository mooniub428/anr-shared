% Load dependencies
load_coretools();

% Load configuration
dataNameSrc = 'cylinder';
dataNameTrg = 'cylindernew';
%data_name = 'horse';
%data_name = 'camel';


viSrc = [263, 245]; % 479 299]';
viTrg = [227, 198]; % 395 262]';
fi = 23;

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
        newDistance = EuclideanHistogramNorm(DescriptorsSrc(i, :), DescriptorsTrg(j, :));
        if(newDistance < distance)
            distance = newDistance;
            matchId = j;
        end % if
    end % for    
    Matches(i) = matchId;
    Distances(i) = distance;
end % for

[viSrc Matches Distances]


