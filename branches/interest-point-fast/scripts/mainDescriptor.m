%% Configuraiton
% Load dependencies
load_coretools();

% Load configuration
param = config('descriptor_test2');
%param = config('triangle');

%% Surface deformation
% Transform obj sequence into matlab readable format and load it (conditional)
objseq = objseq2mat(param);

% Compute surface deformation
[D, E] = recompute_strain(objseq.V, objseq.triangles, objseq.n_f, objseq.n_t);
% Switch from triangle to vertex strain formulation
D_ = tri2vert_strain(D, objseq.triangles, objseq.n_v, objseq.n_f);

%% Adjacency
A = triangulation2adjacency(objseq, param, D_);
A = full(A); % get full matrix from a sparse matrix 

%% Pyramid
sigma = param.smooth_num_space;
tau = param.smooth_num_time;

%DescriptorFine(objseq.vertices, objseq, D_, A, 258, 2, sigma, tau);
DescriptorPrincipalAxes(objseq.vertices, objseq.triangles, objseq, A, 258, 2, sigma, tau);

%H2 = Descriptor(objseq.vertices, objseq, D_, A, 20, 2, sigma, tau);
%H1-H2