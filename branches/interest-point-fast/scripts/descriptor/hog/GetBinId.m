function [bin_id] = GetBinId(x, num_bins)

angle = RotAngle(x);
if(angle < 0)
    angle = 2*pi + angle;
end % if

radial_width = (2 * pi) / num_bins;

bin_id = ceil(angle / radial_width);
if(bin_id == 0)
    bin_id = 1;
end % if

end % function

