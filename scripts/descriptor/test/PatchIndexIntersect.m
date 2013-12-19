function [Patch, Patch_prime] = PatchIndexIntersect(Patch, Patch_prime)

[, ip, ip_prime] = intersect(Patch, Patch_prime);
n = size(Patch_prime, 1);
Patch(4. :) = ip';
Patch_prime(4, :) = [1 : n]';

end % function

