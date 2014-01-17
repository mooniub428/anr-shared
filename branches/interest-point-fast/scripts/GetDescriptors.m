function [Descriptors] = GetDescriptors(data_name, viList, fi)

load([data_name '.mat']);
param = config(data_name);

numOfVert = numel(viList);

% Apply threshold on minimal deformation value
n_v = size(D_, 1);
sigma_ = param.smooth_num_space;
tau_ = param.smooth_num_time;
D_ = get_at_scale(n_v, pyramid, 4, 4, sigma_, tau_);
D_(D_ < param.strain_min) = 0.0;

Descriptors = cell(numOfVert, 2);

% Compute descriptors
for i = 1 : numOfVert
    % Source
    vi = viList(i);    
    [HoG, VolumeWithDenselValues] = DescriptorFine(objseq.vertices, D_, A, vi, fi, sigma_, tau_, param);    
    HoP = DescriptorPrincipalAxes(objseq.vertices, objseq.triangles, VolumeWithDenselValues, E, A, vi, fi, sigma_, tau_, param);
    Descriptors(i, 1) = {HoG};
    Descriptors(i, 2) = {HoP};
end % for

end % function

