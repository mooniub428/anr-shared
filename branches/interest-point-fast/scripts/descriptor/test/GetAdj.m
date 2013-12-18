function [A] = GetAdj(DistMatrix, h)

A = DistMatrix <= sqrt(2) * h;

end % function

