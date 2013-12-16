function [ objseq ] = objseq2mat( param )

% Load the data
if( exist(param.data_file, 'file') )
    load(param.data_file); % vertices/triangles/V
end % if


if( ~exist(param.data_file, 'file') || ~exist('objseq', 'var') || param.recompute_all )
    % Preprocess the data
    listing = dir([param.data_folder 'obj/']);
    num_files = numel(listing);
    
    
    matlabpool('open', 6);
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
    matlabpool close;
    
    disp(['Saving ' param.data_file]);
    
    objseq.vertices = reshape(V(:, :, 1), size(V, 1), 3);
    objseq.triangles = triangles;
    objseq.V = V;
    objseq.n_v = size(V, 1); % number of vertices
    objseq.n_t = size(triangles, 1); % number of triangles
    objseq.n_f = size(V, 3); % number of frames in the animation

    save(param.data_file, 'objseq');
end % if



end % function
