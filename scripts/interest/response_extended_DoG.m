function [response] = response_extended_DoG(pyramid, n_v, n_f, sigma, tau, param)

response = (-1) * ones((tau + 1) * (sigma + 1) * n_v, n_f);

max_sigma = sigma;
sigma = sigma + 1;
max_tau = tau;
tau = tau + 1;
step = param.step;
for t_i = step + 1 : step : max_tau
    for s_i = step + 1 : step : max_sigma
        [S22, from_id, to_id] = get_at_scale(n_v, pyramid, s_i, t_i, sigma, tau); % Left-Up
        [S11, ~] = get_at_scale(n_v, pyramid, s_i - step, t_i - step, sigma, tau); % Left
        [S12, ~] = get_at_scale(n_v, pyramid, s_i - step, t_i , sigma, tau); % Left-Bottom        
        [S21, ~] = get_at_scale(n_v, pyramid, s_i, t_i - step, sigma, tau); % Bottom
        
        %feat_response = abs(S22 + S11 - S12 - S21);  
        %feat_response = abs(S22 - S12);
        %feat_response = abs(S22 - S21);
        %feat_response = S22 - S11;
        feat_response = 2*S22 - S12 - S21;
        
        response(from_id : to_id, :) = feat_response;                           
    end % for
end % for

% Save color reflecting strain in reference scale
disp('Saving color..');
from_id = 1;
to_id = n_v;
%S00 = pyramid(from_id : to_id, :);
R11 = get_at_scale(n_v, response, 2, 3, sigma, tau);
S00 = get_at_scale(n_v, pyramid, 1, 1, sigma, tau);
S00_vector = zeros(n_v * n_f, 1);
R11_vector = zeros(n_v * n_f, 1);
for i = 1 : n_f
    S00_vector( (i-1) * n_v + 1 : i * n_v) = S00(:, i);
    R11_vector( (i-1) * n_v + 1 : i * n_v) = R11(:, i);
end % for
%S00_vector = reshape(S00', numel(S00), 1); % Vectorized form of reference scale S00
C = produce_color(S00_vector) / 255.0;

% Create export directory if it does not exist
enforce_existence('../debug/');
export_dir = ['../debug/' param.data_name '/'];
enforce_existence(export_dir);

CFileName = [export_dir 'ColorsVertexStrain.txt'];
save(CFileName, 'C', '-ascii');

C = produce_color(R11_vector) / 255.0;
CFileName = [export_dir 'ColorsVertexResponse.txt'];
save(CFileName, 'C', '-ascii');


end % function

