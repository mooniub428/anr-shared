function [response] = response_extended_DoG(pyramid, n_v, n_f, sigma, tau, param)

response = (-1) * ones((tau + 1) * (sigma + 1) * n_v, n_f);

%step = param.step;
for t_i = step + 1 : step : tau
    for s_i = step + 1 : step : sigma                        
        [S11, from_id, to_id] = get_at_scale(n_v, pyramid, s_i, t_i, sigma, tau); % Left-Up
        [S22, ~] = get_at_scale(n_v, pyramid, s_i - step, t_i - step, sigma, tau); % Left
        [S12, ~] = get_at_scale(n_v, pyramid, s_i - step, t_i , sigma, tau); % Left-Bottom        
        [S21, ~] = get_at_scale(n_v, pyramid, s_i, t_i - step, sigma, tau); % Bottom
        
        feat_response = abs(S22 + S11 - S12 - S21);        
        response(from_id : to_id, :) = feat_response;                           
    end % for
end % for

% Save color reflecting strain in reference scale
disp('Saving color..');
from_id = 1;
to_id = n_v;
S00 = pyramid(from_id : to_id, :);
S00_vector = reshape(S00', numel(S00), 1); % Vectorized form of reference scale S00
C = produce_color(S00_vector) / 255.0;

% Create export directory if it does not exist
enforce_existence('../debug/');
export_dir = ['../debug/' param.data_name '/'];
enforce_existence(export_dir);

CFileName = [export_dir 'Colors.txt'];
save(CFileName, 'C', '-ascii');


end % function

