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
param.recompute_all = true; 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
param.visualize_strain = true; % export .PLY files with color-coded vertex strains
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
param.data_name = data_name;
% Input data file is supposed to be there
param.data_folder = ['../../fr.unistra.icube-igg.dyndat/' data_name '/']; 
param.data_file = [param.data_folder data_name '.mat'];
% Path to file which contains n-ring pre-computed neighbourhoods
param.window_file = [param.data_folder param.data_name '-window.mat'];

% Function to define local maxima in "scale space" domain (inter-octave)
param.response_fn_scale = @diff_of_gauss;
% Function to define local maxima in "space-time" domain (intra-octave)
%param.response_fn_spacetime = @pure_strain;
param.response_fn_spacetime = @diff_of_gauss;

% Define space-time window
param.window = boxcar_window(1, 1); % 1-ring neigh. both in space and time

% Frame number to start with
param.f0 = 1;
% Number of frames to consider in animation sequence
param.n_f = 40;

% Linear scale space representation)
param.smooth_num = 10; % Total number of octaves: smooth_num x smooth_num (recommended to be < 50) 
param.octave_step = 1; % Period for sparse sampling of scales 

% Find extreme in space-time
param.extrema_space_time = true;
% Find extrema in scale
param.extrema_scale = true;

% Minimal magnitude of principal strain taken into consideration
param.strain_min = 0.01;
param.feature_response_min = 0.02;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

param.spins = cell(7);
param.spins(1) = {'|'};
param.spins(2) = {'/'};
param.spins(3) = {'-'};
param.spins(4) = {'\'};
param.spins(5) = {'|'};
param.spins(6) = {'/'};
param.spins(7) = {'-'};   

end % function

