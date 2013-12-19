function [A] = GetAdj(DistMatrix, h)

A = DistMatrix <= sqrt(2) * h;
n = size(A, 1)
for i = 1 : n
    A(i, i) = 0;
end % for

end % function

