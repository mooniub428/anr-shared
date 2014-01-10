function [octantId, octantCenter] = GetOctantId(THETA, PHI, Volume)
    if(PHI >= 0)
        if(THETA > 0)
            if(THETA < pi/2)
                octantId = 1;
                octantCenter = [0.5 0.5 Volume.upperMargin/2];
            else
                octantId = 2;
                octantCenter = [-0.5 0.5 Volume.upperMargin/2];
            end % if
        else
            if(THETA < -pi/2)
                octantId = 3;
                octantCenter = [-0.5 -0.5 Volume.upperMargin/2];
            else
                octantId = 4;
                octantCenter = [0.5 -0.5 Volume.upperMargin/2];
            end % if
        end % if
    else
        if(THETA > 0)
            if(THETA < pi/2)
                octantId = 5;
                octantCenter = [0.5 0.5 -Volume.upperMargin/2];
            else
                octantId = 6;
                octantCenter = [-0.5 0.5 Volume.upperMargin/2];
            end % if
        else
            if(THETA < -pi/2)
                octantId = 7;
                octantCenter = [-0.5 -0.5 Volume.upperMargin/2];
            else
                octantId = 8;
                octantCenter = [0.5 -0.5 Volume.upperMargin/2];
            end % if
        end % if
    end % if
end % function