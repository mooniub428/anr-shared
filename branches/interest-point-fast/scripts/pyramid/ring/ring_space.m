function [A_] = ring_space(A, n_v, ws)
% ws - window size in space (ring unit)

if(ws < 1)
    err = MException('Filter:range');
    throw(err);
elseif(ws == 1)
    A_ = A;
else
    % A_ - get next ring
    A_ = zeros(n_v);
    A_ = A_ | A;
    for i = 1 : n_v
        for j = 1 : n_v
            if(A(i, j))
                A_(i, :) = A_(i, :) | A(j, :);
            end % if
        end % for
    end % for
    
    A_ = ring_space(A_, n_v, ws - 1);
end % if

end % function

