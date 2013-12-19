function [Patch, Patch_prime] = PatchIndexIntersect(Patch, Patch_prime)

n = size(Patch, 1);
ip = zeros(n, 1);

for i = 1 : n
    p = Patch(i, :);
    id = 1;
    q = Patch_prime(id, :);
    
    while(norm(p - q) > 0)
        id = id + 1;
        q = Patch_prime(id, :);
    end % while
    
    ip(i) = id;
end % for

Patch(:, 4) = ip;
Patch_prime(:, 4) = [1 : size(Patch_prime, 1)]';

end % function

