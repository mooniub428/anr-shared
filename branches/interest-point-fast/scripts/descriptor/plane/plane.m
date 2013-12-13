% a*x + b*y + c*z + d = 0
% Given 3 points x, y, z
%
function [a b c] = plane(x, y, z, d)

D = det([x y z]);

a = (-d / D) * det([ones(3, 1) y z]);
b = (-d / D) * det([x ones(3, 1) z]);
c = (-d / D) * det([x y ones(3, 1)]);


end % function

