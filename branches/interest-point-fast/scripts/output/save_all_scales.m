function [] = save_all_scales(export_dir, IP, IP_mesh, V, sigma, tau, bb_max_diag)

% Count the number of interest points
IP_count = sum(sum(IP));

% If interest points detected
if(IP_count > 0)
    T = zeros(IP_count, 3); % Translation
    S = zeros(IP_count, 1); % Scale
    C = zeros(IP_count, 3); % Color
    TauScales = zeros(IP_count, 1);
    
    color_range = produce_color([1 : tau]) / 255;
    
    % Get interest point coordinates 
    [I, J] = find(IP == 1);
    n_v = size(V, 1);
    for i = 1 : IP_count
        v_i = mod(I(i), n_v) + (~mod(I(i), n_v))*n_v;        
        f_i = J(i);
        T(i, :) = V(v_i, :, f_i);
        
        l = ceil(I(i) / n_v);
        r = mod(l, tau);
        t_i = tau;
        if(r > 0)
            t_i = r;
        end % if
        s_i = (l - t_i) / tau + 1;
        
        S(i) = 0.02 * s_i * bb_max_diag;
        C(i, :) = color_range(t_i, :);
        
        
    end % for
    
    % Export interest points accroding to matrices T, S, C
    opacity = 0.3;
    n_f = size(V, 3);    
    export_IP_obj(export_dir, IP_mesh, J, T, S, C, opacity, n_f);
end % if

end % function

