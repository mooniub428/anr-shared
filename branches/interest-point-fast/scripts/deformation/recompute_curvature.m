%% Curvature
% vertices: 3 by n_v (# of vertices) by n_f(# of frames) matrix.
% ATTENTION: 'vertices' needs rearrangements before calling the
% 'compute_curvature' function.
function [ C ] = recompute_curvature ( vertices, triangles, n_v, n_f )

disp('*');
disp('Curvature :: Recompute Curvature');
disp('*');

% Array 'vertices' need rearrangements
V = permute(vertices, [2 1 3]);

% Options copied from the 'test_curvature.m'.
%options.covariance_smoothing = 15;
%options.normal_scaling = 1.5;
%options.curvature_smoothing = 10;

% Options copied from the 'test_curvature.m'.
options.covariance_smoothing = 10;
options.normal_scaling = 1.5;
options.curvature_smoothing = 5;

% Compute per-vertex curvature, for each frame
C_ = zeros(n_v, n_f);
C = zeros(n_v, n_f);

for f_i = 1 : n_f % iterate over all frames
    disp(['Recompute curvature :: Processing frame ' int2str(f_i)]);
    [Umin,Umax,Cmin,Cmax,Cmean,Cgauss,Normal] = compute_curvature(V(:, :, f_i),triangles, options);
    C_ (:, f_i) = Cmax;
end % for

% To be alternatively used as the block below..
C = C_;

for f_i = 1 : n_f 
    C (:, f_i) = C_(:, f_i) - C_(:, 1); % Change of curvature w.r.t. the initial frame
end % for

end % function
