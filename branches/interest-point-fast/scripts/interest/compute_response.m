function [response] = compute_response(pyramid, n_v, n_f, sigma, tau, param)

response = (-1) * ones((tau + 1) * (sigma + 1) * n_v, n_f);

sigma = sigma + 1;
tau = tau + 1;

for t_i = 1 : (tau-1)
    for s_i = 1 : (sigma-1)
        from_id = (s_i - 1) * tau * n_v + 1 + (t_i - 1) * n_v;
        to_id = (s_i - 1) * tau * n_v + t_i * n_v;
        S11 = pyramid(from_id : to_id, :);
        
        from_id_ = s_i * tau * n_v + 1 + t_i * n_v;
        to_id_ = s_i * tau * n_v + (t_i + 1) * n_v;
        S22 = pyramid(from_id_ : to_id_, :);
        
        
        feat_response = abs(S22 - S11);
        response(from_id_ : to_id_, :) = feat_response;
        if( (t_i == 1) || (s_i == 1) )
            response(from_id : to_id, :) = feat_response;
        %elseif( (t_i == (tau-1)) || (s_i == (sigma-1)) )
        end % if
        
        if(param.DoG_new)
            from_id = s_i * tau * n_v + 1 + (t_i - 1) * n_v;
            to_id = s_i * tau * n_v + t_i * n_v;
            S12 = pyramid(from_id_ : to_id_, :);
            
            from_id = (s_i - 1) * tau * n_v + 1 + t_i * n_v;
            to_id = (s_i - 1) * tau * n_v + (t_i + 1) * n_v;
            S21 = pyramid(from_id : to_id, :);
            response(from_id_ : to_id_, :) = abs(S22 + S11 - S12 - S21);
        end % if        
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
enforce_existence('../../fr.unistra.icube-igg.debug/');
export_dir = ['../../fr.unistra.icube-igg.debug/' param.data_name '/'];
enforce_existence(export_dir);

CFileName = [export_dir 'Colors.txt'];
save(CFileName, 'C', '-ascii');


end % function
