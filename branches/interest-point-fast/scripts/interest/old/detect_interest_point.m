function [IP] = detect_interest_point(response, A, n_v, n_f, sigma, tau, eps, step)

disp('Detect interest points ::');

% Interest points
IP = zeros(n_v * sigma * tau, n_f);

for t_i = step + 1 : step : tau - step 
    for s_i = step + 1 : step : sigma - step
        %% Extrema in scale
        [L, from_id_, to_id_] = get_at_scale(n_v, response, s_i, t_i, sigma, tau); % Center
        
        B = zeros(n_v, n_f); % Boolean matrix to indicate interest points
                        
        [L1, ~] = get_at_scale(n_v, response, s_i - step, t_i - step, sigma, tau); % Left-Up
        [L2, ~] = get_at_scale(n_v, response, s_i - step, t_i, sigma, tau); % Left
        [L3, ~] = get_at_scale(n_v, response, s_i - step, t_i + step, sigma, tau); % Left-Bottom        
        [L4, ~] = get_at_scale(n_v, response, s_i, t_i + step, sigma, tau); % Bottom
        
        [L5, ~] = get_at_scale(n_v, response, s_i + step, t_i + step, sigma, tau); % Bottom-Right
        [L6, ~] = get_at_scale(n_v, response, s_i + step, t_i, sigma, tau); % Right
        [L7, ~] = get_at_scale(n_v, response, s_i + step, t_i - step, sigma, tau); % Right-Up
        [L8, ~] = get_at_scale(n_v, response, s_i, t_i - step, sigma, tau); % Up                        
        
        B = ((L - L1) <= 0) + ((L - L2) <= 0) + ((L - L3) <= 0) + ...
            + ((L - L4) <= 0) + ((L - L5) <= 0) + ((L - L6) <= 0) + ...
            + ((L - L7) <= 0) + ((L - L8) <= 0) + (L <= eps);
        
        %% Extrema in space-time
        % 1. Time
        L_next = circshift(L, [0 1]);
        L_next(:, 1) = zeros(1, n_v);
        L_prev = circshift(L, [0 -1]);
        L_prev(:, n_f) = zeros(1, n_v);
        B = B + ((L - L_prev) <= 0) + ((L - L_next) <= 0);
        
                 
        % 2. Space
        for v_i = 1 : n_v
            adj = find(A(v_i, :) > 0);
            adj = adj'; % to column vector          
            
            for f_i = 1 : n_f
                B(v_i, f_i) = B(v_i, f_i) + (L(v_i, f_i) - max(L(adj, f_i)) <= 0);   
            end % for            
        end % for        
        
        %gather(B);
        
        %% 
        IP(from_id_ : to_id_, :) = (B == 0);
        
    end % for
end % for

end % function

