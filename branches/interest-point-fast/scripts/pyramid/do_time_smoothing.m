function [ pyramid ] = do_time_smoothing( pyramid, D_, tau )

n_v = size(D_, 1);
n_f = size(D_, 2);

% T is 1-ring remporal filter matrix
% S(n+1) = S(n)*T
T = zeros(n_f, n_f);
n_f = n_f - 1;
T(1,1) = 1/2;
T(2,1) = 1/2;
for k = 2 : n_f
    T(k-1, k) = 1/3;
    T(k, k) = 1/3;    
    T(k+1, k) = 1/3;
end % for
T(n_f, n_f+1) = 1/2;
T(n_f+1, n_f+1) = 1/2;

tau = tau + 1;
for i = 2 : tau      
    from_id = (i - 2) * n_v + 1;
    to_id = (i-1) * n_v;
    
    S = pyramid(from_id : to_id, :); % current scale
    Sn = S * T; % next scale
    
    from_id = (i - 1) * n_v + 1;
    to_id = i * n_v;
    pyramid(from_id : to_id, :) = Sn;
end % for

end % function

