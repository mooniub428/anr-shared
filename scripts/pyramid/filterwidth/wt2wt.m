function [w2, n2] = wt2wt(w1, f2, f1, n1)
if(n1 == 0)
    w2 = sqrt((w1^2 - 1) * (f2/f1)^2 + 1);
    w2 = floor(w2);
    n2 = 0;
else
    n2 = n1 * (f2/f1)^2;
    w2 = 0;
end % if
end % function

