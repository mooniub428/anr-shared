function [] = save_all_scales(export_dir, response, IP, IP_mesh, V, sigma, tau, bb_max_diag)

% Count the number of interest points
IP_count = sum(sum(IP));

% If interest points detected
if(IP_count > 0)
    T = zeros(IP_count, 3); % Translation
    S = zeros(IP_count, 1); % Scale
    C = zeros(IP_count, 3); % Color    
    
    color_range = produce_color([1 : tau]) / 255;
    
    % Get interest point coordinates 
    [I, J] = find(IP == 1); % J is a vector of frame ids with interest points
    n_v = size(V, 1);
    VIndex = zeros(numel(I), 1);
    
    % Matrix containing space-time characteristic scales
    ST = zeros(IP_count, 2);
    
    for i = 1 : IP_count
        v_i = mod(I(i), n_v) + (~mod(I(i), n_v))*n_v;        
        VIndex(i) = v_i;
        f_i = J(i);
        T(i, :) = V(v_i, :, f_i);
        
        l = ceil(I(i) / n_v);
        r = mod(l, tau);
        t_i = tau;
        if(r > 0)
            t_i = r;
        end % if
        s_i = (l - t_i) / tau + 1;
        
        % Populate characteristic scale matrix
        ST(i, 1) = s_i;
        ST(i, 2) = t_i;
        
        S(i) = 2.0e-2 * nthroot(s_i, 3) * bb_max_diag;
        C(i, :) = color_range(t_i, :);

    end % for
    
    export_IP_index(export_dir, VIndex, J, response, IP, ST);
    
    % Export interest points accroding to matrices T, S, C
    opacity = 0.3;
    n_f = size(V, 3);    
    export_IP_obj(export_dir, IP_mesh, J, T, S, C, opacity, n_f);
end % if

end % function

