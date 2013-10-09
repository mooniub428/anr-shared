function [ D_ ] = tri2vert_strain( D, objseq, param )

%load(param.data_file);

%if(~exist('D_', 'var'))
    disp('*');
    disp('Convert triangle strain to vertex strain');
    disp('*');
    
    n_v = objseq.n_v;
    D_ = zeros(n_v, objseq.n_f);
    
    for vi = 1 : n_v
        adj_tri = sum(objseq.triangles == vi, 2);
        adj_tri_id = find(adj_tri);  
        for fi = 1 : objseq.n_f
            D_(vi, fi) = mean(D(adj_tri_id, fi));
        end % for
    end % for
%end % if

save(param.data_file, 'objseq', 'D_'); 

end % function

