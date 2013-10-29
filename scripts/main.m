function [] = main()

%% Configuraiton
% Load dependencies
load_coretools();

% Load configuration
param = config('cylinder2');

%% Surface deformation

matlabpool open 8;

% Transform obj sequence into matlab readable format and load it (conditional)
objseq = objseq2mat(param);

% Compute surface deformation
tic;
[D] = recompute_strain(objseq.V, objseq.triangles, objseq.n_f, objseq.n_t);

% Switch from triangle to vertex strain formulation
D_ = tri2vert_strain(D, objseq.triangles, objseq.n_v, objseq.n_f); 

%% Adjacency
A = triangulation2adjacency(objseq, param, D_);
A = full(A); % get full matrix from a sparse matrix 

%% Pyramid
sigma = param.smooth_num;
tau = param.smooth_num;
pyramid = zeros((tau + 1) * (sigma + 1) * objseq.n_v, objseq.n_f);
pyramid(1:objseq.n_v, :) = D_; % set base scale
% Put it to GPU 
%pyramid = gpuArray(pyramid);
disp('Pyramid ::');
pyramid = do_time_smoothing(pyramid, D_, tau); 
pyramid = do_space_smoothing(pyramid, A, D_, sigma, tau); 

%% Feature response
disp('Feature response ::');
response = (-1) * ones((tau + 1) * (sigma + 1) * objseq.n_v, objseq.n_f);
%response = gpuArray(response);
response = compute_response(pyramid, response, objseq.n_v, sigma, tau, param);

%% Interest point extraction
eps = 0.0001;
IP = detect_interest_point(response, A, objseq.n_v, objseq.n_f, sigma, tau, eps);
% Bring back to cpu
%response = gather(response);
alg_elapsed_time = toc;

IP_union = export_interest_point(objseq, param, IP, sigma, tau);

% Shut down Matlab workers
matlabpool close;

alg_elapsed_time

end % function

