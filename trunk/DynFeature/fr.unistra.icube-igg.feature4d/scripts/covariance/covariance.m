function [ R ] = covariance( objseq, S, D, param )

% Compute local covariance matrices in the space-time neighbourhoods
R = zeros(param.n_dim, param.n_dim, objseq.n_t, objseq.n_f); 

% Local local neighbourhood/window
window_file = ['data/' param.data_name '-window.mat'];
load(window_file);
% Evaluate window variable value
N = eval(['N' int2str(param.sigm_l)]);

tic;
for f_i = 2 : objseq.n_f % iterate over all frames    
    disp(['Covariance :: Processing frame ' int2str(f_i)])
    for t_i = 1 : objseq.n_t % in each frame iterate over all triangles
        strain_local = get_strain_local(S, N, t_i, f_i, param);
        % Get covariance matrix
        R(:,:, t_i, f_i) = cov(strain_local);
    end % for
end % for
toc;

end % function

