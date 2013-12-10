function [] = main_vcfd(data_name, fid, ei)
% Load dependencies
load_coretools();
% Load configuration
param = config(data_name);

objseq = objseq_single_frame(param, fid);

Vf = get_vector_field(squeeze(objseq.V(:, :, 2)), squeeze(objseq.V(:, :, 1)), objseq.triangles, ei);
%[x, y, z, u, v, w] = PostProcessVectorField(Vf);
export2vtk(data_name, Vf(:,1),Vf(:,2),Vf(:,3),Vf(:,4), Vf(:,5), Vf(:,6));
quiver3(Vf(:,1),Vf(:,2),Vf(:,3),Vf(:,4), Vf(:,5), Vf(:,6));

end % function

