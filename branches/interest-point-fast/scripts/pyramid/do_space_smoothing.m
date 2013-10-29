function [ pyramid ] = do_space_smoothing( pyramid, A, D_, sigma, tau )

n_v = size(D_, 1);

% A - vertex adjacency matrix
% S(n+1) = A*S(n)

M = sum(A,2) + 1; % "+1" it is because we include point of consideration itself
for i = 1 : n_v
    A(i, i) = 1;
    A(i, :) = A(i, :) / M(i);
end % for

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

