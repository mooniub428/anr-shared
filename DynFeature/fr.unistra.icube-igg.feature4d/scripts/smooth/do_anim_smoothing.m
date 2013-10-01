function [ octaveset ] = do_anim_smoothing( D_, param, objseq )


if(~exist('octaveset', 'var'))
    disp('*');
    disp('Octaveset :: Compute Scale-Space Representation');
    disp('*');
    
    n_v = objseq.n_v;
    
    octaveset = cell(param.smooth_num, param.smooth_num);    
    
    % Iterate octaves starting from 2nd, since 1st is equal to not-filtered
    % animation    
    start_octave = D_;
    
    % The 1st raw of of the octave: smoothing with increasing "sigma" only
    
    
    % The 1st column of the octave: smoothing with increasing "tau" only
    
    
    % Smothing loop for increasing "tau"
    for i = 1 : param.smooth_num        
        disp(['Smoothing :: ' num2str(100 * i / param.smooth_num, 2) '%..'])
        if(i > 1)
            start_octave = cell2mat(octaveset(i-1, 1));
            window.tau = 1;
            window.sig = 0; 
        else
            window.tau = 1; 
            window.sig = 1; 
        end % if                
        
        % Smoothing loop for increasing "sigma"
        for j = 1 : param.smooth_num
            
            new_octave = zeros(n_v, param.n_f);
            % Go through all vertices
            for vi = 1 : n_v
                % and find adjacent vertices
                adj_vertices = find(objseq.adj_vert(vi, :) > 0);
                % Iterate over frames as well
                for fi = 1 : param.n_f                    
                    new_octave(vi, fi) = do_local_smoothing(start_octave, window, vi, fi, adj_vertices, param);
                end % for each frame
            end % for each vertex                        
                        
            window.tau = 0;
            window.sig = 1; 
            
            start_octave = new_octave;
            octaveset(i, j) = {new_octave};
        end % for each "sigma"        
    end % for each "tau"
end % if

save(param.data_file, 'objseq', 'D_', 'octaveset'); 

end % function

