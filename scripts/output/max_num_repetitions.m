function [max_num_rep] = max_num_repetitions(A)

if(iscolumn(A))
    A = A';
end % if

[val I J]=unique(A);
rep=diff(find(diff([-Inf sort(J) Inf])));
val;
rep;

max_num_rep = max(rep);

end % function

