function [response] = response_space_DoG(pyramid, n_v, n_f, sigma, tau, param)

response = (-1) * ones((tau + 1) * (sigma + 1) * n_v, n_f);


for t_i = 1 : (tau)
    for s_i = 1 : (sigma)
        from_id = (s_i - 1) * tau * n_v + 1 + (t_i - 1) * n_v;
        to_id = (s_i - 1) * tau * n_v + t_i * n_v;
        S11 = pyramid(from_id : to_id, :);
        
        from_id_ = s_i * tau * n_v + 1 + t_i * n_v;
        to_id_ = s_i * tau * n_v + (t_i + 1) * n_v;
        S22 = pyramid(from_id_ : to_id_, :);
        
        feat_response = abs(S22 - S11);
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

