% Produces a configurational object "param" which aggregates all constants,
% parameters, treshold and other user-defined properties which are used in
% the main algorithm

function param = config(data_name)

param.data_name = data_name;
param.data_folder = ['../../fr.unistra.icube-igg.dyndat/' data_name '/']; 

param.smooth_num = 8; % Total number of octaves: smooth_num x smooth_num (recommended to be < 50) 
param.step = 1; % Defines how many 1-ring smoothings spawn one octave
param.DoG_new = false;

% Minimal magnitude of principal strain taken into consideration
param.strain_min = 0.01;
param.feature_response_min = 0.04;

end % function
