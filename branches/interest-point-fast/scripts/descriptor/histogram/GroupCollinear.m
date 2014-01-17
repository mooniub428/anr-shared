function [HoGCell] = GroupCollinear(HoGCell)

HoG = cell2mat(HoGCell);
[nx, ny] = size(HoG);
for i = 1 : floor(nx / 2)
    collinearGroup = HoG(i, :) + HoG(nx - i + 1, :);
    HoG(i, :) = collinearGroup;
    HoG(nx - i + 1, :) = collinearGroup;
end % for

for j = 1 : floor(ny / 2)
    collinearGroup = HoG(:, j) + HoG(:, ny - j + 1);
    HoG(:, j) = collinearGroup;
    HoG(:, ny - j + 1) = collinearGroup;
end % for

HoGCell = {HoG};

end % function

