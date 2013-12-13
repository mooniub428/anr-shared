% % a*x + b*y + c*z + d = 0
% Given 3 points a, b, c, d, x, y
% Compute corresponding z coordinate
%
function [z] = z4planeXY(a, b, c, d, x, y)

if(c ~= 0)
    z = (-1 / c) * (a * x + b * y + d);
end % if

end % function

