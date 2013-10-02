% Data set name
param.data_name = 'horse';
param.do_scale_norm = 'true';

cd('..');
% Load precomputed data
load_precomputed_data(param);

% Threshold for feature response
eps = 0.4;

% Filter raw feature point set
featpts_filtered = postprocess_featpts( featpts, eps )
featpts = featpts_filtered;

% Modify the directory for export
param.data_name = [param.data_name '_' num2str(eps)];

% Export all the frames OBJ files augmented with spheres on feature point
% locations
vertices_with_spheres = export_feature_vis( D_, objseq, param, featpts );

% Export extracted features (raw featpts i.e. without filtering)
export_featpts_mat(featpts, param);

% Export strain color during the animations
export_anim_color( feature_response, vertices_with_spheres, param );

cd('postprocess');