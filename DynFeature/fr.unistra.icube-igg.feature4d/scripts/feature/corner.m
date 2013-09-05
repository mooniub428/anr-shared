function [ featp ] = corner( corner_function, R, param )

disp('');
disp(':: Corner Detection');

% Init feature point set (empty set)
featp = [0 0];
featcount = 0;

% Local local neighbourhood/window
window_file = ['data/' param.data_name '-window.mat'];
load(window_file);
% Evaluate window variable value
N = eval(['N' int2str(param.sigm_l)]);

n_t = size(R, 3);

% Find local maxima in the corner responses
% foreach frame
for f_i = 2 : param.n_f
    
    % borders in time
    % i.e. time interval [f0, fn]
    f0 = f_i - param.tau_l;
    fn = f_i + param.tau_l;
    if(f0 < 2)
        f0 = 2;
    end % if
    if(fn > param.n_f)
        fn = param.n_f;
    end % if
    
    % In each frame iterate over all triangles
    for t_i = 1 : n_t 
        r = reshape(R(:,:,t_i,f_i), param.n_dim, param.n_dim);
        h = corner_function(r, param.harris_k);
        
        islocmax = true;
        nwin = nonzeros(N(t_i, :));
        nwin = setdiff(nwin, t_i);
        
        for i = 1 : size(nwin, 1)
            tri = nwin(i);
            
            for j = f0 : fn
                r = reshape(R(:, :, tri, j), param.n_dim, param.n_dim);
                hn = corner_function(r, param.harris_k);
                disp('');
                if(h <= hn)
                    islocmax = false;
                end % if
            end % for
        end % for
        
        if(islocmax)
            featcount = featcount + 1;
            featp(featcount, :) = [t_i, f_i];
        end % if
    end % for
end % for

end % function

