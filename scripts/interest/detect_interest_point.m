function [IP] = detect_interest_point(response, A, n_v, n_f, sigma, tau, eps, step)

disp('Detect interest points ::');

% Interest points
%IP = parallel.gpu.GPUArray.zeros(n_v * sigma * tau, n_f);
IP = zeros(n_v * sigma * tau, n_f);
tau = tau - 1;
sigma = sigma - 1;

%gpuArray(A);
for t_i = 2 : step : tau
    for s_i = 2 : step : sigma
        %% Extrema in scale
        [L, from_id_, to_id_] = get_at_scale(n_v, response, s_i, t_i, sigma, tau); % Center
        %from_id_ = (s_i - 1) * tau * n_v + 1 + (t_i - 1) * n_v;
        %to_id_ = (s_i - 1) * tau * n_v + t_i * n_v;
        %L = response(from_id_ : to_id_, :); % current scale
        
        B = zeros(n_v, n_f); % Boolean matrix to indicate interest points
                        
        [L1, ~] = get_at_scale(n_v, response, s_i-1, t_i-1, sigma, tau); % Left-Up
        [L2, ~] = get_at_scale(n_v, response, s_i-1, t_i, sigma, tau); % Left
        [L3, ~] = get_at_scale(n_v, response, s_i-1, t_i+1, sigma, tau); % Left-Bottom        
        [L4, ~] = get_at_scale(n_v, response, s_i, t_i+1, sigma, tau); % Bottom
        
        [L5, ~] = get_at_scale(n_v, response, s_i+1, t_i+1, sigma, tau); % Bottom-Right
        [L6, ~] = get_at_scale(n_v, response, s_i+1, t_i, sigma, tau); % Right
        [L7, ~] = get_at_scale(n_v, response, s_i+1, t_i-1, sigma, tau); % Right-Up
        [L8, ~] = get_at_scale(n_v, response, s_i, t_i-1, sigma, tau); % Up
        
        % Left-Top
        %from_id = (t_i - 2) * n_v + 1 + (s_i - 2) * n_v;
        %to_id = (t_i - 2) * n_v + (s_i - 1) * n_v;
        %L1 = response(from_id : to_id, :);
        
        % Left
        %from_id = (t_i - 2) * n_v + 1 + (s_i - 1) * n_v;
        %to_id = (t_i - 2) * n_v + s_i * n_v;
        %L2 = response(from_id : to_id, :);
        
        % Left-Bottom
        %from_id = (t_i - 2) * n_v + 1 + s_i * n_v;
        %to_id = (t_i - 2) * n_v + (s_i + 1) * n_v;
        %L3 = response(from_id : to_id, :);
        
        % Up
        %from_id = (t_i - 1) * n_v + 1 + (s_i - 2) * n_v;
        %to_id = (t_i - 1) * n_v + (s_i - 1) * n_v;
        %L4 = response(from_id : to_id, :);
        
        % Up-Right
        %from_id = t_i * n_v + 1 + (s_i - 2) * n_v;
        %to_id = t_i * n_v + (s_i - 1) * n_v;
        %L5 = response(from_id : to_id, :);
        
        % Right
        %from_id = t_i * n_v + 1 + (s_i - 1) * n_v;
        %to_id = t_i * n_v + s_i * n_v;
        %L6 = response(from_id : to_id, :);
        
        % Right-Bottom
        %from_id = t_i * n_v + 1 + s_i * n_v;
        %to_id = t_i * n_v + (s_i + 1) * n_v;
        %L7 = response(from_id : to_id, :);
        
        % Bottom
        %from_id = (t_i - 1) * n_v + 1 + s_i * n_v;
        %to_id = (t_i - 1) * n_v + (s_i + 1) * n_v;
        %L8 = response(from_id : to_id, :);
        
        
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
        
%         s = whos('L');
%         memory_required = s.bytes;
%         s = gpuDevice();
%         gpu_memory = s.TotallMemory;
        %gpuL = L;
        %gpuArray(gpuL);
        %gpuArray(B);
                 
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

