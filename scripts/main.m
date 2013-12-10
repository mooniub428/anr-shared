function [] = main()

%% Configuraiton
% Load dependencies
load_coretools();

% Load configuration
param = config('cylinder');

%% Surface deformation

matlabpool open 7;

% Transform obj sequence into matlab readable format and load it (conditional)
objseq = objseq2mat(param);

% Compute surface deformation
tic;
if(param.region_deformation)
    rgnRad = mean(mean(objseq.Gd)) * 0.02;
    [D] = VertRegionDeformation(objseq.V, objseq.triangles, rgnRad, objseq.Gd);
    D_ = D;
else
    [D] = recompute_strain(objseq.V, objseq.triangles, objseq.n_f, objseq.n_t);
    % Switch from triangle to vertex strain formulation
    D_ = tri2vert_strain(D, objseq.triangles, objseq.n_v, objseq.n_f); 
end % if

%% Adjacency
A = triangulation2adjacency(objseq, param, D_);
A = full(A); % get full matrix from a sparse matrix 

%% Pyramid
sigma = param.smooth_num_space;
tau = param.smooth_num_time;

% Adapt cut off frequency
%tau = floor(compute_filter_number(8, 8.0, 48.0));
%sigma = floor(compute_filter_number(8, 0.0, 0.0));
%mean_edge = mean_edge_anim(objseq.V, A);

pyramid = zeros((tau + 1) * (sigma + 1) * objseq.n_v, objseq.n_f);
pyramid(1 : objseq.n_v, :) = D_; % set base scale

disp('Pyramid ::');
pyramid = do_time_smoothing(pyramid, D_, tau, param.wt); 
pyramid = do_space_smoothing(pyramid, A, D_, sigma, tau, param.ws); 

%% Feature response
disp('Feature response ::');
if(param.diag_DoG)
    response = response_diag_DoG(pyramid, objseq.n_v, objseq.n_f, sigma, tau, param);
elseif(param.extended_DoG)
    response = response_extended_DoG(pyramid, objseq.n_v, objseq.n_f, sigma, tau, param);
else % param.space_DoG = true;
    response = response_space_DoG(pyramid, objseq.n_v, objseq.n_f, sigma, tau, param);
end % if


%% Interest point extraction
eps = 0.1;
IP = detect_interest_point(response, A, objseq.n_v, objseq.n_f, sigma, tau, eps, param.step);

alg_elapsed_time = toc;

%export_interest_point(objseq, param, IP, sigma, tau);
save_interest_point(objseq, param, response, IP, sigma, tau); % save a sequence of OBJ files representing interest points

% Shut down Matlab workers
matlabpool close;

alg_elapsed_time

numOfIP = sum(sum(IP))

end % function

