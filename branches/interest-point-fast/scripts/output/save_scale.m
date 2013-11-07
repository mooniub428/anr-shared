function [] = save_scale(objseq, IP_at_scale, response_at_scale, s_i, t_i)

disp(['Exporting scale (' int2str(s_i) ', ' int2str(t_i) ')..']);
% Create subfolder for that scale

% Save an animation

% Estimate max number of IP per frame
IP_max_num = max(sum(IP_at_scale, 2));

for f_i = 1 : objseq.n_f
    for v_i = 1 : objseq.n_v
    end % for
end % for

% Produce color
disp('Saving.. color')


end % function

