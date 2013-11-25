function [ pyramid ] = do_time_smoothing(pyramid, D_, tau, wt)
% wt - time window

n_v = size(D_, 1);
n_f = size(D_, 2);

% T is 1-ring remporal filter matrix
% S(n+1) = S(n)*T
T = ring_time(n_f, wt);

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

