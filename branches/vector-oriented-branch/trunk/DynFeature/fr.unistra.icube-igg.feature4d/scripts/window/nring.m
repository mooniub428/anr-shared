% Returns a n-ring triangle neighbourhood (ring) with a vector (ring_id)
% of.. corresponding ring ids

function [ring, ring_id] = nring(n, ti, objseq, param, cur_ring, cur_ring_id)

% Stop condition
if(n > param.sigm_l)
    ring = cur_ring;
    ring_id = cur_ring_id;
else
    % Get vertices of a triangle
    t_v = objseq.triangles(ti, :);
    
    % Get closest ring neighbourhood
    next_ring = find( sum(ismember(objseq.triangles, t_v), 2) )';
    next_ring = setdiff(next_ring, cur_ring);
    if( numel(cur_ring) > 0 )
        ring = [cur_ring next_ring];
    else
        ring = next_ring;
    end % if
    ring_id = [cur_ring_id ones(1, numel(next_ring)) * n];
    
    % Number of triangles in the neighbourhood
    k = numel(next_ring);
    % Recursively get (n+1)-ring neighbourhoods
    for i = 1 : k
        tj = next_ring(i);
        if(ti ~= tj)
            [ring, ring_id] = nring((n + 1), tj, objseq, param, ring, ring_id);  
        end %
    end % for
end % if

end % function

