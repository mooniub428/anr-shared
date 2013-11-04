function [ objseq ] = objseq2mat( param )


% Preprocess the data
listing = dir([param.data_folder 'obj/']);
num_files = numel(listing);


% skip '.' and '..' in dir output
next_file = [param.data_folder 'obj/' listing(3).name];
[vertices, triangles] = read_wobj(next_file);
V = zeros( size(vertices, 1), 3, (num_files - 2));
V(:,:,1) = vertices;

parfor i = 4 : num_files
    next_file = [param.data_folder 'obj/' listing(i).name];
    [vertices, triangles] = read_wobj(next_file);
    V(:,:, i-2) = vertices;
end % for

objseq.vertices = reshape(V(:, :, 1), size(V, 1), 3);
objseq.triangles = triangles;
objseq.V = V;
objseq.n_v = size(V, 1); % number of vertices
objseq.n_t = size(triangles, 1); % number of triangles
objseq.n_f = size(V, 3); % number of frames in the animation

end % function

