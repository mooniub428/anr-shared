% Produces a configurational object "param" which aggregates all constants,
% parameters, treshold and other user-defined properties which are used in
% the main algorithm

function param = config(data_name)

param.data_name = data_name;
param.data_folder = ['../dyndat/' data_name '/']; 

param.correct_indexing = false;
param.region_deformation = false;
%param.smooth_num = 12; % Total number of octaves: smooth_num x smooth_num (recommended to be < 50) 

% Important moving average parameters
param.smooth_num_space = 13;
param.smooth_num_time = 13;
param.wt = 3; % time window size
param.ws = 1; % space window size (ring unit)

param.diag_DoG = false;
param.extended_DoG = true;
param.space_DoG = false;

param.step = 3; % Defines how many 1-ring smoothings spawn one octave
param.space_step = 0.1;
param.time_step = 0.1; % sampling interval in space domain inside characteristic volume
param.space_step = 0.1; % sampling interbal in time domain inside characteristic volume

% Minimal magnitude of principal strain taken into consideration
param.strain_min = 0.0001;
param.feature_response_min = 0.04;

end % function

