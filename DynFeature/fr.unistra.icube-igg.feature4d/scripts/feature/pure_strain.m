function [ s ] = pure_strain( param, octaveset, i, j, frame_id, vi )

if( (i < 1) || (i > param.smooth_num) || (j < 1) || (i > param.smooth_num) )
    s = 0.0;
elseif( (i < param.smooth_num) && (j < param.smooth_num) )
    o = cell2mat(octaveset(i,j));
    s = o(vi, frame_id);
else
    s = 0.0;
end % if



end % function

