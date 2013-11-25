function [ pyramid ] = do_space_smoothing( pyramid, A, D_, sigma, tau, ws )
% ws - window size in space

n_v = size(D_, 1);

% A - vertex adjacency matrix
% S(n+1) = A*S(n)

A = ring_space(A, n_v, ws);
A = A | eye(n_v);
M = sum(A, 2);
M = repmat(M, 1, n_v);
A = A ./ M;

tau = tau + 1;
sigma = sigma + 1;
for t_i = 1 : tau
    for s_i = 2 : sigma
        from_id = (s_i - 2) * n_v * tau + 1 + (t_i - 1) * n_v;
        to_id = (s_i - 2) * n_v * tau + t_i * n_v;
        
        S = pyramid(from_id : to_id, :);
        Sn = A * S;
        
        from_id = (s_i - 1) * n_v * tau + 1 + (t_i - 1) * n_v;
        to_id = (s_i - 1) * n_v * tau + t_i * n_v;
        
        pyramid(from_id : to_id, :) = Sn;
    end % for
end % for

end % function

