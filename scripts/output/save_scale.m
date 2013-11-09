function [] = save_scale(scale_dir, objseq, IP_mesh, IP_at_scale, response_at_scale, s_i, t_i)

disp(['Exporting scale (' int2str(s_i) ', ' int2str(t_i) ')..']);

% Estimate max number of IP per frame
IP_max_num = max(sum(IP_at_scale, 2));

% Save interest point "coordinates"
[I, J] = find(IP_at_scale == 1);
IJ(:, 1) = I; IJ(:, 2) = J;
save([scale_dir 'InterestPoints.txt'], 'IJ', '-ascii');

% If at least one interest point has been detected
if(IP_max_num > 0)
    T = zeros(IP_max_num, 3);
    S = zeros(IP_max_num, 1);
    C = zeros(IP_max_num, 3);
    
    % Export IP mesh for each frame of the animation
    for f_i = 1 : objseq.n_f
        I = find(IP_at_scale(:, f_i) == 1);
        k = numel(I);
        
        % Translate(T), scale(S) and compute color(C) 
        for i = 1 : k
            produce_color();
            S(k, :) = [1.0 1.0 1.0];
        end % for
        
        % Collapse the rest        
        k = k + 1;
        for i = k : IP_max_num
            T(k, :) = [0.0 0.0 0.0];
            S(k) = 0.0;
            C(k, :) = [0.0 0.0 0.0];
        end % for
        
        % Save obj file with MTL (material file)
        opacity = 0.42;
        export_IP_obj(obj_name, IP_mesh, T, S, C, opacity);
    end % for
end % if

% Produce color
disp('Saving.. color')
C = produce_color(response_at_scale) / 255; % normalize for feat_point plugin
save([scale_dir 'Color.txt'], 'C', '-ascii');

end % function

