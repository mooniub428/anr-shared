function [ L ] = convolution( N, D, param, objseq )

disp(':: Convolution');
tic;
L = [0.0 0.0 0.0];

% Iterate over frames
for f_i = 1 : param.n_f
    % Iterates over triangles
    for t_i = 1 : objseq.n_t
        % Compute convolution in a local neighbourhood
        % i.e. Smoothing/blending with Gaussian Kernel
        f0 = f_i - param.tau_l;
        fn = f_i + param.tau_l;
        if(f0 < 2)
            f0 = 2;
        end % if
        if(fn > param.n_f)
            fn = param.n_f;
        end % if
        
        for i = f0 : fn
            for j = 1 : param.sigm_l
                win =  
                x = win(j); % space coordinate
                t = i; % time coordinate
                w = gausskernel(x, t, param.sigm_l);
                d = reshape( D() )
                L = L + w * d;
            end % for
        end % for
        
    end % for
end % for

toc;

end % function

