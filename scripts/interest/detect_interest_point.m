function [IP] = detect_interest_point(response, A, n_v, n_f, sigma, tau, eps, step)

disp('Detect interest points ::');

param = config('');

if(param.correct_indexing)
	max_sigma = sigma;
	sigma = sigma + 1;
	max_tau = tau;
	tau = tau + 1;    
end % if

% Interest points
IP = zeros(n_v * sigma * tau, n_f);

step = param.step;
for t_i = step + 1  : step : max_tau - step
    for s_i = step + 1  : step : max_sigma - step
        %% Extrema in scale
        [L, from_id_, to_id_] = get_at_scale(n_v, response, s_i, t_i, sigma, tau); % Center
        
        B = zeros(n_v, n_f); % Boolean matrix to indicate interest points
                        
        [L1, ~] = get_at_scale(n_v, response, s_i-step, t_i-step, sigma, tau); % Left-Up
        B1 = ((L - L1) <= 0);
        
        [L2, ~] = get_at_scale(n_v, response, s_i-step, t_i, sigma, tau); % Left
        B2 = ((L - L2) <= 0);
        
        [L3, ~] = get_at_scale(n_v, response, s_i-step, t_i+step, sigma, tau); % Left-Bottom
        B3 = ((L - L3) <= 0);
        
        [L4, ~] = get_at_scale(n_v, response, s_i, t_i+step, sigma, tau); % Bottom
        B4 = ((L - L4) <= 0);
        
        [L5, ~] = get_at_scale(n_v, response, s_i+step, t_i+step, sigma, tau); % Bottom-Right
        B5 = ((L - L5) <= 0);
        
        [L6, ~] = get_at_scale(n_v, response, s_i+step, t_i, sigma, tau); % Right
        B6 = ((L - L6) <= 0);
        
        [L7, ~] = get_at_scale(n_v, response, s_i+step, t_i-step, sigma, tau); % Right-Up
        B7 = ((L - L7) <= 0);
        
        [L8, ~] = get_at_scale(n_v, response, s_i, t_i-step, sigma, tau); % Up                        
        B8 = ((L - L8) <= 0);
        
        B0 = (L <= eps);
        X32 = reshape (L, 1, size(L,1)*size(L,2));
        thresholds = prctile(X32,[5 99.5]); 
        
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
            
            nadj = size(adj, 2);
            
            for f_i = 1 : n_f
                B(v_i, f_i) = B(v_i, f_i) + (L(v_i, f_i) - max(L(adj, f_i)) <= 0);   
                if(f_i > 1)
                    B(v_i, f_i) = B(v_i, f_i) + (L(v_i, f_i) - max(L(adj, f_i - 1)) <= 0);   
                end % if
                if(f_i < n_f)
                    B(v_i, f_i) = B(v_i, f_i) + (L(v_i, f_i) - max(L(adj, f_i + 1)) <= 0);   
                end % if
            end % for            
        end % for        
        
        %gather(B);
        
        %% SHW: Eliminate all IP's at the first and the last frame
        B(:,1) = 1;
        B(:,n_f) = 1;
        
        %% 
        IP(from_id_ : to_id_, :) = (B == 0);
        
    end % for
end % for

end % function

