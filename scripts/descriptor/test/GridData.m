function [Patch, Patch_prime, F, F1, Fv, F1v, v, h] = GridData()

k = 32;
h = 1;
v = 2 : h : (k + 1);

[X, Y] = meshgrid(v);
Patch.X = X;
Patch.Y = Y;
Patch.Z = zeros(k);
[X, Y] = meshgrid(1 : h : (k + 2));
Patch_prime.X = X;
Patch_prime.Y = Y;
Patch_prime.Z = zeros(k + 2);

F_line = [];
for i = 1 : k
    F_line = [(i - 1)^2 F_line];
end % for
F = [];
Fv = [];
for i = 1 : k
    F = [F; F_line];
    Fv = [Fv F_line]; 
end %
Fv = Fv';

%%

F1_line = 0;
for i = 1 : k + 2    
    F1_line = [(i - 1)^2 F1_line];
end % for
F1_line = [(i - 1)^2 F1_line];


F1 = [];
F1v = [];
for i = 1 : k + 2
    F1 = [F1; F1_line];
    F1v = [F1v F1_line];
end % for
F1v = F1v';

F1 = X .* exp(-Y.^2 - Y.^2);

end % function

