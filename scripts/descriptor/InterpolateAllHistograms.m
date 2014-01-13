function [Histograms] = InterpolateAllHistograms(Histograms)
    for i = 1 : 8
        H = InterpolateSingleHistogram(cell2mat(Histograms(i)));
        Histograms(i) = mat2cell(H);
    end % for
end % function

function [H] = InterpolateSingleHistogram(H)
    [numRows, numCols] = size(H);
    [row, col, v] = find(H);
    
    X = [];
    H = H / max(max(H));
    for i = 1 : numRows
        for j = 1 : numCols
            numOfSamples = floor(H(i, j) * 30);
            for k = 1 : numOfSamples
                X = [X; [i j]];
            end % for
        end % for
    end % for     
    smoothhist2D(X, 1, [numRows numCols])
    
    %x = row;
    %y = col;    
    %v = v;
    %[xq, yq] = meshgrid(1:numCols, 1:numRows);    
    %Interpolator = TriScatteredInterp(x,y,v,'nearest');
    %HInterp = Interpolator(xq, yq);
end % function

