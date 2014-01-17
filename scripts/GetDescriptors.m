function [Descriptors] = GetDescriptors(data_name, viList, fi)

load([data_name '.mat']);
param = config(data_name);

%Pyramid
sigma = param.smooth_num_space;
tau = param.smooth_num_time;

numOfVert = numel(viList);

% Apply threshold on minimal deformation value
D_(D_ < param.strain_min) = 0.0;

Descriptors = cell(numOfVert, 2);

% Compute descriptors
for i = 1 : numOfVert
    % Source
    vi = viList(i);    
    [HoG, VolumeWithDenselValues] = DescriptorFine(objseq.vertices, D_, A, vi, fi, sigma, tau, param);    
    HoP = DescriptorPrincipalAxes(objseq.vertices, objseq.triangles, VolumeWithDenselValues, E, A, vi, fi, sigma, tau, param);
    Descriptors(i, 1) = {HoG};
    Descriptors(i, 2) = {HoP};
end % for

end % function

