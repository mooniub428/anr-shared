function [ D ] = recompute_strain( objseq, param )

% 
% dorecompute = 0;
% if(~exist('D', 'var') || param.recompute_all)
%     dorecompute = 1;
% elseif(~exist('S', 'var') || param.recompute_all)
%     %dorecompute = 1;
% elseif( size(D, 3) ~= param.n_f )
%     dorecompute = 1;
% end % if
    
dorecompute = true;
if(dorecompute)
    disp('*');
    disp('Strain :: Recompute Strain');
    disp('*');
    
    tic;
    V = objseq.V;
    
    % Compute per-triangle strain 
    S = zeros(objseq.n_t, 3, objseq.n_f);
    S_tensor = zeros(objseq.n_t, 3, 3, objseq.n_f);
    D = zeros(objseq.n_t, 3, objseq.n_f);
    
    for f_i = 2 : objseq.n_f % iterate over all frames
        disp(['Recompute strain :: Processing frame ' int2str(f_i)]);
        for t_i = 1 : objseq.n_t % compute shear values for each triangle
            tr = objseq.triangles(t_i, :);
            v_hat = V(tr,:,f_i); % after deformation
            %v = V(tr,:,f_i - 1);     % before deformation
            v = V(tr,:, 1);
            [E, D_eigen] = local_strain_tensor(v, v_hat);
            S_tensor(t_i, :, :, f_i) = E;
            D(t_i, :, f_i) = diag(D_eigen);
            
            %D_eigen = abs(max(D_eigen) - 1.0);
            %D_eigen = max(D_eigen) - 1.0;
            %id_of_max = find(floor(D_eigen/max(D_eigen)));
            %max_strain = E(:, id_of_max);
            %S(t_i, :, f_i) = max_strain;
        end % for
    end % for
    
    %tri_strain = S;
    save(param.data_file, 'objseq', 'D');    
    toc;
else
    %S = tri_strain;
    %D = D_eigen;
end % if

end % function

