function [ D_ ] = tri2vert_strain( D, triangles, n_v, n_f )

disp('*');
disp('Convert triangle strain to vertex strain');
disp('*');

D_ = zeros(n_v, n_f);

parfor vi = 1 : n_v
    adj_tri = sum(triangles == vi, 2);
    adj_tri_id = find(adj_tri);
    for fi = 1 : n_f
        D_(vi, fi) = mean(D(adj_tri_id, fi));
    end % for
end % for

end % function

