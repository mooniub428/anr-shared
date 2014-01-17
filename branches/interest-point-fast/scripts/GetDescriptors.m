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
    
    numOfOctants = size(HoG, 1);
    if(param.normalize_solid_angle)
        for i = 1 : numOfOctants
            HoG(i, 1) = NormalizeSolidAngle(HoG(i, 1));
            HoP(i, 1) = NormalizeSolidAngle(HoP(i, 1));
        end % for
    end % if
    if(param.group_collinear)
        for i = 1 : numOfOctants
            %HoG(i, 1) = GroupCollinear(HoG(i, 1));
            HoP(i, 1) = GroupCollinear(HoP(i, 1));
        end % for        
    end % if
    
    Descriptors(i, 1) = {HoG};
    Descriptors(i, 2) = {HoP};
end % for

end % function

