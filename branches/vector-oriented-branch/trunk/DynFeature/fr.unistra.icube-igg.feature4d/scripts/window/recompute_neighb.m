function [ nvar ] = recompute_neighb( objseq, param )

window_file = param.window_file;

try
    load(window_file);
catch
    disp('Window :: No Window File Found');
end % try


nvar = ['N' int2str(param.sigm_l)];
if(~exist(nvar, 'var') ||  param.recompute_all)
    tic;
    disp('Window :: Recompute neighbourhood');
    N = 1 : objseq.n_t;
    N = N';
    Nid = N;
    
    for ti = 1 : objseq.n_t
        [ring, ring_id] = nring(1, ti, objseq, param, [], []);
        endpoint = numel(ring);
        % dirty trick to change dimension of the array
        N(ti, endpoint) = 0;
        Nid(ti, endpoint) = ring_id;
        N(ti, 1 : endpoint) = ring;
    end % for
    
    save_neighb(nvar, N, Nid);
    save(window_file, nvar);
    toc;
end % if

end % function

