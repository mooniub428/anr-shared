function [D_] = retain_max_strain( D )
    n_v = size(D, 1);
    n_f = size(D, 3);
    D_ = zeros(n_v, n_f);
    
    for vi = 1 : n_v
        for fi = 1 : n_f
            D_(vi, fi) = max(abs(reshape(D(vi, :, fi), 3, 1) - 1.0));
        end % for
    end % for
       
end % function

