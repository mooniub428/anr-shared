function [F, F1, v, h] = GridData()

k = 5;
h = 1;
v = 1 : h : k;
[X, Y] = meshgrid(v);
Z = zeros(k);

%F = [ [2 2 2]; [2 4 4]; [2 4 8] ];
%F = [ [2 2 2]; [4 4 4]; [8 8 8] ];
F = [ [8 4 2 1 0]; [8 4 2 1 0]; [8 4 2 1 0]; [8 4 2 1 0]; [8 4 2 1 0] ];

F1 = [];
for i = 1 : k + 2
    F1 = [F1; [0 8 4 2 1 0 0]];
end % for

end % function

