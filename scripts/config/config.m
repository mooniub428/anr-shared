% Produces a configurational object "param" which aggregates all constants,
% parameters, treshold and other user-defined properties which are used in
% the main algorithm

% Takes "data_name" as input parameter, which is a name of data to be used
% e.g. 'cylinder', 'horse-gallop' etc.

function param = config(data_name)

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Set it to TRUE in order to recompute every step from scratch including full
% pre-processing: that might be of use when changing input data sets, for
% example
param.recompute_all = false; 
param.recompute_octaveset = false;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
param.visualize_strain = true; % export .PLY files with color-coded vertex strains
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
param.data_name = data_name;
% Input data file is supposed to be there
param.data_folder = ['../../fr.unistra.icube-igg.dyndat/' data_name '/']; 


% Linear scale space representation)
param.smooth_num = 8; % Total number of octaves: smooth_num x smooth_num (recommended to be < 50) 
param.do_scale_norm = false;
param.DoG_new = false;

% Minimal magnitude of principal strain taken into consideration
param.strain_min = 0.01;
param.feature_response_min = 0.04;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

end % function

