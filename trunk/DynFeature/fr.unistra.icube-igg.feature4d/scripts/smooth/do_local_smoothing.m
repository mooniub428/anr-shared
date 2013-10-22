function [ smoothed_value ] = do_local_smoothing(start_octave, window, vi, fi, adj_vertices, param)

if(window.sig < 1)
    adj_vertices = [];
end % for
    adj_vertices = [adj_vertices vi];   % SHW: Insert itself for the smoothing

if(window.tau < 1)
    frame_in_past = fi;
    frame_in_future = fi;
else
    % Identify frame index in the past to start smoothing
    X = fi - window.tau;
    Y = 1;
    COND = X > Y;
    frame_in_past = COND.*X + (~COND).*Y;
    
    % Identify frame index in the future to end smoothing
    X = fi + window.tau;
    Y = param.n_f;
    COND = X < Y;
    frame_in_future = COND.*X + (~COND).*Y;
    
end % if


neighb = start_octave(adj_vertices, frame_in_past : frame_in_future);
neighb = reshape(neighb, size(neighb,1) * size(neighb,2), 1);
smoothed_value = mean(neighb);

end % function

