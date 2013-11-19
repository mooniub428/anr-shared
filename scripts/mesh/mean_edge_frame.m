function [mean_edge] = mean_edge_frame(vertices, A)

n_v = size(vertices, 1);

cell_vertices = num2cell(vertices, 2);
C_vertices = repmat(cell_vertices, 1, n_v);

Diff = cellfun(@minus, C_vertices, C_vertices', 'uni', false);
D = cellfun(@norm, Diff);

mean_edge = mean(D(A>0));

end % function

