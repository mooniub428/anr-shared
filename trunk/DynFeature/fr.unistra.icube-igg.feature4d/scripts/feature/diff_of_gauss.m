function [ dog ] = diff_of_gauss(param, octaveset, i, j, fi, vi )

if( (i < 1) || (i > param.smooth_num) || (j < 1) || (i > param.smooth_num) )
    dog = 0.0;
elseif( (i < param.smooth_num) && (j < param.smooth_num) )
    next_octave = cell2mat(octaveset(i+1, j+1));
    curr_octave = cell2mat(octaveset(i, j));
    dog = abs(curr_octave(vi, fi) - next_octave(vi, fi));
else
    dog = 0.0;
end % if

end % function

