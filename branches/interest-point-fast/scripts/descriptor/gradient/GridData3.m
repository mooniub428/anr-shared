function [Patch, Patch_prime, F, F1, Fv, F1v, v, h] = GridData3()

h = 0.5;
m = 4;
v = -m/2 : h : m/2; 
k = size(v, 2);
[x,y] = meshgrid(v);

sinx = arrayfun(@sin, x);
cosy = arrayfun(@sin, y);
z = sinx' * cosy;


F = z;
F1 = F;
Fv = reshape(F, k^2, 1);
F1v = Fv;

Patch_prime.X = x;
Patch_prime.Y = y;
Patch_prime.Z = zeros(k);
Patch = Patch_prime;

end % function

