function [R] = RotMatrixZ(angle)

R = [
    [cos(angle) -sin(angle) 0];
    [sin(angle) cos(angle) 0];
    [0 0 1]
    ];

end % function

