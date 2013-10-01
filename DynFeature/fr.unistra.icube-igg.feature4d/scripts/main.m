% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Input: sequence of .obj files representing an animated mesh;
% Output: a set of interest points extracted from the animation;
%
% The implementation is mainly based on the following work:
% Indexing based on scale invariant interest points, Mikolajczyk and Schmid;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% Define empty cell array to store extracted feature points (if any)
global featpts;
featpts = cell(0, 1);

%
% Load dependencies
load_coretools();

% Load configuration
%param = config('cylinder');
param = config('cylinder-with-stop');
%param = config('horse-gallop');

% Transform obj sequence into matlab readable format and load it (conditional)
objseq = objseq2mat(param);
objseq.n_f = param.n_f;
load(param.data_file);

% Force to use certain subset of frames in .obj sequence
%objseq.n_f = 10;
objseq.n_f = param.n_f;

% Recompute stain (conditional) and/or load it into environment
[D] = recompute_strain(objseq, param); % could be commented temporarily % 
D = retain_max_strain(D); % i.e. out of 3 eigen values retain only maximal one % could be commented temporarily % 

% Switch from triangle to vertex strain formulation  
D_ = tri2vert_strain(D, objseq, param); % could be commented temporarily % 
D_(:,1) = 0.0;

% Export obj sequence with the strain visualization
%export_strain_vis(D_, objseq, param);

% Compute vertex adjacency matrix
objseq.adj_vert = triangulation2adjacency(objseq.triangles, objseq.vertices);

% Compute linear scale space representation of the animation
octaveset = do_anim_smoothing(D_, param, objseq); % could be commented temporarily %

% Extract sparse interest points according to a feature response function
% (DoG)
disp('Extract interest points ::');
interest_point = zeros(objseq.n_v, objseq.n_f);
tic
for fi = 1 : objseq.n_f
    
    %clc;
    %disp([num2str(100 * vi / objseq.n_v, 2) '%..'])
    %spinner(param, vi); % spinner to show the progress of computation
    
    for vi = 1 : objseq.n_v
        % Check if vertex (vi) in frame (fi) is an extrema in any of the
        % scales both in space-time and scale domains
        is_interest_point = extract_interest_point(objseq, octaveset, vi, fi, param, param.response_fn_scale, param.response_fn_spacetime);   
        %is_interest_point = extract_interest_point(objseq, octaveset, vi, fi, param, @pure_strain);
        % If iterest point detected write it to console
        if(is_interest_point)
            interest_point(vi, fi) = true;
            %disp(['[' int2str(vi) ', ' int2str(fi) ']']); % vertex id and frame id
        end % if
    end % for
end % for
toc
%
cell2mat(featpts)

%
vertices_with_spheres = export_feature_vis( D_, objseq, param, featpts );

% Export strain color during the animations
export_anim_color( D_, vertices_with_spheres );
