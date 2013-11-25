function [T] = ring_time(n_f, w)
% w - desirable window size (number of neighbourhood rings in time)

T = zeros(n_f, n_f);

for l = 1 : floor(w / 2)
    wl = l + floor(w / 2);
    for k = 1 : wl
        T(k, l) = 1 / wl;
    end % for
end % for

for k = ceil(w / 2) : (n_f - floor(w / 2))
    for i = [-floor(w / 2) : floor(w / 2)]
        offset = i;
        T(k + offset, k) = 1 / w;
    end % for 
end % for


offset = 1;
for l = (n_f - floor(w / 2) + 1) : n_f
    wl = w - offset;    
    for k = [n_f : - 1 : (n_f - wl + 1)]
        T(k, l) = 1 / wl;
    end % for
    offset = offset + 1;
end % for


end % function

