function [ baryc ] = GetBarycenter( v, tri, id )

t = tri(id, :)';
baryc = mean(v(t, :));

end % function

