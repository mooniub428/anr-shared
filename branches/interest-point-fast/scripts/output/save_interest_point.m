function [] = save_interest_point(objseq, param, IP, response, sigma, tau)

% Create export directory if it does not exist
enforce_existence('../../fr.unistra.icube-igg.debug/');
export_dir = ['../../fr.unistra.icube-igg.debug/' param.data_name '/'];
enforce_existence(export_dir);

% Clean export_dir
system(['erase /s /q ' export_dir '*']);

% 1. Export IP at each scale separately
for t_i = 1 : tau
    for s_i = 1 : sigma
        % if there are interest points at scale then save to export_dir
        IP_at_scale = get_at_scale(objseq.n_v, IP, s_i, t_i, sigma, tau);        
        response_at_scale = get_at_scale(objseq.n_v, response, s_i, t_i, sigma, tau);
        ip_count = sum(sum(IP_at_scale));
        if(ip_count > 0)
            save_scale(objseq, IP_at_scale, response_at_scale, s_i, t_i);
        end % if
    end % for space
end % for time

% 2. Export at all scales 
for f_i = 1 : objseq.n_f
    for v_i = 1 : objseq.n_v
    end % for
end % for


end % function

