function [ is_interest_point ] = extract_interest_point(objseq, octaveset, vi, fi, param, response_fn_scale, response_fn_spacetime)

    for i = param.octave_step : param.octave_step : param.smooth_num        
        for j = 1  : param.octave_step : param.smooth_num            
            
            is_interest_point = true;
            
            feature_response_curr = response_fn_scale(param, octaveset, i, j, fi, vi);                    
            
            if(param.extrema_scale)
                % Condition #1: Extrema in scale
                end_loop = false;
                for k = -1 : 1
                    if(end_loop == true)
                        break; 
                    end    
                    for l = -1 : 1
                        if((k == 0) && (l==0))
                            continue;
                        end
                        
                        feature_response_neighb = response_fn_scale(param, octaveset, i + k, j + l, fi, vi);
                        if(feature_response_neighb > feature_response_curr)
                            is_interest_point = false; 
                            end_loop = 1; break;      
                        end % if
                    end % for
                end % for
            end % if
            
            % Condition #2: Extrema in space-time
            if(param.extrema_space_time)
                % Find one ring neighbours in space
                one_ring_space = find(objseq.adj_vert(vi, :) > 0);
                time_start = 1;
                time_end = objseq.n_f;
                if(fi > 1)
                    time_start = fi - 1;
                end % if
                if(fi < objseq.n_f)
                    time_end = fi + 1;
                end % if
                % One ring neighbours in time
                one_ring_time = time_start : time_end;
                
                end_loop = false;
                for frame_id = one_ring_time
                    for vert_id = [one_ring_space vi];  % add 
                        feature_response_neighb = response_fn_spacetime(param, octaveset, i, j, frame_id, vert_id);
                        if(feature_response_neighb >= feature_response_curr)
                            if(vert_id~=vi)
                                is_interest_point = false; end_loop = true; break; 
                            elseif(frame_id~=fi)
                                is_interest_point = false; end_loop = true; break; 
                            end
                        end % if                        
                    end % for
                end % for
            end % if
            
            cur_octave = cell2mat(octaveset(i,j));
            
            if(is_interest_point && (cur_octave(vi, fi) > param.strain_min) )
                [i, j]
                return;
            end
        end % for
    end % for    
end % function

