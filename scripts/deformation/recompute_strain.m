function [ D ] = recompute_strain( V, triangles, n_f, n_t )

disp('*');
disp('Strain :: Recompute Strain');
disp('*');

% Compute per-triangle strain
D = zeros(n_t, n_f);

parfor f_i = 2 : n_f % iterate over all frames
    disp(['Recompute strain :: Processing frame ' int2str(f_i)]);
    for t_i = 1 : n_t % compute shear values for each triangle
        tr = triangles(t_i, :);
        v_hat = V(tr,:,f_i); % after deformation
        %v = V(tr,:,f_i - 1);     % before deformation
        v = V(tr,:, 1);
        [~, D_eigen] = local_strain_tensor(v, v_hat);        
        D(t_i, f_i) = max(abs(diag(D_eigen) -[1.0; 1.0; 1.0]));        
    end % for
end % for

end % function

