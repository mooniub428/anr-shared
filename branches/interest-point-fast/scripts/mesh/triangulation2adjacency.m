function A = triangulation2adjacency(objseq, param, D_)

% triangulation2adjacency - compute the adjacency matrix
%   of a given triangulation.
%
%   A = triangulation2adjacency(face);
% or for getting a weighted graph
%   A = triangulation2adjacency(face,vertex);

face = objseq.triangles;
vertex = objseq.vertices;

% Check if adjaceny information has been already computer
try
    A = objseq.adj_vert;
    recompute_adj_vert = false;    
catch
    recompute_adj_vert = true;
end % try

if(recompute_adj_vert || param.recompute_all)
    
    disp('*');
    disp(':: Compute adjacency matrix');
    disp('*');
    
    [tmp,face] = check_face_vertex([],face);
    f = double(face)';
    
    A = sparse([f(:,1); f(:,1); f(:,2); f(:,2); f(:,3); f(:,3)], ...
        [f(:,2); f(:,3); f(:,1); f(:,3); f(:,1); f(:,2)], ...
        1.0);
    % avoid double links
    A = double(A>0);
    
    return;
    
    
    nvert = max(max(face));
    nface = size(face,1);
    A = spalloc(nvert,nvert,3*nface);
    
    for i=1:nface
        for k=1:3
            kk = mod(k,3)+1;
            if nargin<2
                A(face(i,k),face(i,kk)) = 1;
            else
                v = vertex(:,face(i,k))-vertex(:,face(i,kk));
                A(face(i,k),face(i,kk)) = sqrt( sum(v.^2) );    % euclidean distance
            end
        end
    end
    % make sure that all edges are symmetric
    A = max(A,A');
    
    save(param.data_file, 'objseq', 'param', 'D_');
end % if