% Note: launch the script from the root of source file directory i.e. where
% main.m file is located

% Load dependencies
load_coretools();

% Data set name
param.data_name = 'cylinder-with-stop-large';
param.do_scale_norm = false;

% Load precomputed data
[objseq, D_, feature_response, featpts] = load_precomputed_data(param);

% Threshold for feature response
eps = 0.08;

% Filter raw feature point set
featpts_filtered = postprocess_featpts( featpts, eps )
featpts = featpts_filtered;

% Modify the directory for export
param.data_name = [param.data_name '_' num2str(eps)];

% Export all the frames OBJ files augmented with spheres on feature point
% locations
[vertices_with_spheres, n_spheres, n_sphere_vertices] = export_feature_vis( D_, objseq, param, {featpts} );

% Export extracted features (raw featpts i.e. without filtering)
export_featpts_mat({featpts}, param);

% Export strain color during the animations
export_anim_color( feature_response, featpts, vertices_with_spheres, n_spheres, n_sphere_vertices, param );

%cd('postprocess');